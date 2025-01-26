extends Node

const TIMEOUT := 10.0

# Signals to connect
signal request_log_in
signal request_log_out
signal request_leaderboard(version: String, map: String)
signal request_metadata
signal send_score(score: int, map: String, ai: String, collab_partner: String)

# Signals to emit
signal leaderboard_received(leaderboard: Array)
signal leaderboard_error(error: String)
signal metadata_received(metadata: Array)
signal log_in_succesfull
signal log_out_succesfull

@onready var leaderboard_http = HTTPRequest.new()  # For getting leaderboard
@onready var score_http = HTTPRequest.new()  # For sending score to leaderboard
@onready var oauth = OAuth.new()

var config: ConfigFile

var VERSION: String
var ADDRESS: String
var PASSWORD: String

var logged_in := false
var user_data: Dictionary

var queued_notice_text: String

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Set data
	config = _load_config_file("res://config/prod.cfg")
	if not config:
		return

	set_data()
	var ver_as_num = int(VERSION.replace('.', ''))
	if not (9 < ver_as_num and ver_as_num < 100):
		assert(false, "Version must be in the format x.y")
	load_user_data()

	# Add HTTPRequests
	add_child(leaderboard_http)
	add_child(score_http)

	# Set signals
	request_log_in.connect(_on_request_log_in)
	request_log_out.connect(_on_request_log_out)
	request_leaderboard.connect(_on_request_leaderboard)
	request_metadata.connect(_on_request_metadata)
	send_score.connect(_on_send_score)

	# Setup Oauth
	add_child(oauth)
	oauth.setup(config)

func set_data() -> void:
	VERSION = config.get_value("server", "version")
	ADDRESS = config.get_value("server", "address")
	PASSWORD = config.get_value("server", "password")

func _on_request_metadata() -> void:
	print("Requesting metadata from %s" % ADDRESS)

	var http_request = HTTPRequest.new()
	http_request.timeout = TIMEOUT
	add_child(http_request)

	var body = RequestBody.serialize("get_metadata", {})
	var headers = ["Content-Type: application/json"]
	var err = http_request.request(ADDRESS, headers, HTTPClient.METHOD_POST, body)

	var response = await http_request.request_completed
	var response_code = response[1]

	http_request.queue_free()

	match response_code:
		404:
			print("No metadata yet in server")
			metadata_received.emit(
				[
					{
						"versionNumber":"%s" % VERSION,
						"maps": MapManager.get_names()
					}
				]
			)
		200:
			var response_body = JSON.parse_string(response[3].get_string_from_utf8())

			print("Metadata succesfully received")
			metadata_received.emit(response_body.versions)
		_:
			printerr("Metadata Error: %d" % response_code)
			leaderboard_error.emit()

func _on_request_leaderboard(version: String, map: String) -> void:
	print("Requesting leaderboard data from %s" % ADDRESS)

	var data = {
		"version": version,
		"map": map,
		"version_maps": MapManager.get_names()
	}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = TIMEOUT

	var body = RequestBody.serialize("get_leaderboard", data)
	var headers = ["Content-Type: application/json"]
	var err = http_request.request(ADDRESS, headers, HTTPClient.METHOD_POST, body)

	var response = await http_request.request_completed
	var response_code = response[1]

	http_request.queue_free()

	match response_code:
		404:
			print("No data in server")
			leaderboard_received.emit([])
		200:
			var response_body = JSON.parse_string(response[3].get_string_from_utf8())

			print("Leaderboard succesfully received")
			leaderboard_received.emit(response_body)
		_:
			printerr("Leaderboard Error: %d" % response_code)
			leaderboard_error.emit()

func _on_send_score(score: int, level: int, time: String, map: String, ai: String, collab_partner: String) -> void:
	print("Sending score to %s" % ADDRESS)

	var data = {
		"password": PASSWORD,
		"version_number": VERSION,
		"token": oauth.token,
		"refresh_token": oauth.refresh_token,
		"score": str(score),
		"level": str(level),
		"time": time,
		"map": map,
		"ai": ai,
		"collab_partner": collab_partner,
		"version_maps": MapManager.get_names()
	}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = TIMEOUT

	var body = RequestBody.serialize("add_score", data)

	var headers = ["Content-Type: application/json"]
	var err = http_request.request(ADDRESS, headers, HTTPClient.METHOD_POST, body)
	var response = await http_request.request_completed
	var response_code = response[1]

	http_request.queue_free()

	match response_code:
		200:
			print("Score succesfully sent")
			var response_body = JSON.parse_string(response[3].get_string_from_utf8())
			if response_body["token_refreshed"]:
				oauth.update_tokens(response_body["token"], response_body["refresh_token"])
		401:

			queued_notice_text = "Score could not be sent! Authentication error! Try to log out and log in again."
		403:
			queued_notice_text = "Score could not be sent! You have been banned! :RIPBOZO:"
		_:
			printerr("Score Error: %d" % response_code)
			queued_notice_text = "Score could not be sent! Check internet connection."

func _on_request_log_in() -> void:
	print("Requesting sign in ... ")
	oauth.get_auth_code()
	await oauth.token_recieved

	user_data = await oauth.get_user_data()
	logged_in = true
	print("Welcome %s! login was successful" % user_data.username)
	save_user_data()

	log_in_succesfull.emit()

func _on_request_log_out() -> void:
	print("Logging out ...")
	oauth.revoke_tokens()
	logged_in = false
	user_data = {}
	save_user_data()
	log_out_succesfull.emit()

#region SAVE / LOAD
const SAVE_DIR = "user://user.dat"

func _load_config_file(filename: String) -> Variant:
	var file: ConfigFile = ConfigFile.new()

	var err: Error = file.load(filename)
	if err == Error.ERR_FILE_NOT_FOUND:
		return false

	return file

func save_user_data():
	var file = FileAccess.open_encrypted_with_pass(SAVE_DIR, FileAccess.WRITE, "727")

	var data = {
		"logged_in": logged_in,
		"user_data": user_data
	}

	file.store_var(data)
	file.close()

func load_user_data():
	if FileAccess.file_exists(SAVE_DIR):
		var file = FileAccess.open_encrypted_with_pass(SAVE_DIR, FileAccess.READ, "727")
		var data = file.get_var()

		logged_in = data.logged_in
		user_data = data.user_data

		file.close()
	else:
		save_user_data()
#endregion
