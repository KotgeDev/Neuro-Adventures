extends Node
class_name OAuth

signal token_recieved

var PORT: int
var BINDING: String
var CLIENT_ID: String
var REDIRECT_URI: String
var AUTH_SERVER := "https://discord.com/oauth2/authorize"
var API_ENDPOINT := "https://discord.com/api/v10"

var state = null

var token: String
var refresh_token: String

# Server
var SERVER_ADDRESS: String
var SERVER_PASSWORD: String

func setup(config: ConfigFile) -> void:
	set_process(false)

	PORT = config.get_value("oauth", "port")
	BINDING = config.get_value("oauth", "binding")
	CLIENT_ID = config.get_value("oauth", "client_id")
	REDIRECT_URI = config.get_value("oauth", "redirect_uri")

	SERVER_ADDRESS = config.get_value("server", "address")
	SERVER_PASSWORD = config.get_value("server", "password")

	load_tokens()

#func validate_tokens() -> void:
	#if !(await is_token_valid()):
		#if !(await refresh_tokens()):
			#get_auth_code()

func generate_secure_token(length: int) -> String:
	var crypto = Crypto.new()
	return crypto.generate_random_bytes(length / 2).hex_encode()

func get_auth_code() -> void:
	state = generate_secure_token(16)

	var data = [
		"response_type=code",
		"client_id=%s" % CLIENT_ID,
		"scope=identify",
		"redirect_uri=%s" % REDIRECT_URI,
		"state=%s" % state
	]
	var body = "&".join(data)

	var url = AUTH_SERVER + "?" + body

	OS.shell_open(url)
	_get_token_from_auth()

func _token_get_failed() -> void:
	# TODO: Inform the user
	print("Token request timed out")

func _get_token_from_auth():
	var headers = ["Content-Type: application/json"]

	var http_request = HTTPRequest.new()
	add_child(http_request)

	var data = {
		"state": state
	}

	var body = RequestBody.serialize("get_access_token_from_state", data)

	get_tree().create_timer(3 * 60).timeout.connect(_token_get_failed)

	var response = [0, 0]
	while response[1] != 200:
		await get_tree().create_timer(0.3).timeout
		print("Requesting token from server ...")
		http_request.request(SERVER_ADDRESS, headers, HTTPClient.METHOD_POST, body)
		response = await http_request.request_completed

	var response_body = JSON.parse_string(response[3].get_string_from_utf8())

	token = response_body["access_token"]
	refresh_token = response_body["refresh_token"]

	save_tokens()
	token_recieved.emit()

	http_request.queue_free()
	print("Tokens received!")

## Only call after token_ready has been emited
func get_user_data() -> Dictionary:
	var headers = [
		"Authorization: Bearer %s" % token
	]

	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.request("%s/users/@me" % API_ENDPOINT, headers, HTTPClient.METHOD_GET)

	var response = await http_request.request_completed

	var response_body = JSON.parse_string(response[3].get_string_from_utf8())

	return response_body

#func is_token_valid() -> bool:
	#print("Checking token validity ...")
	#
	#if !token:
		#await get_tree().create_timer(0.001).timeout
		#return false
	#
	#var headers = [
		#"Authorization: Bearer %s" % token
	#]
	#
	#var http_request = HTTPRequest.new()
	#add_child(http_request)
	#
	#var error = http_request.request(
		#"%s/users/@me" % API_ENDPOINT,
		#headers,
		#HTTPClient.METHOD_GET
	#)
	#
	#if error != OK:
		#push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	#
	#var response = await http_request.request_completed
	#
	#var response_body = JSON.parse_string(response[3].get_string_from_utf8())
	#
	#if response_body.has("id"):
		#print("Token is valid!")
		#return true
	#else:
		#print("Token is not valid. Reason: %s" % response_body)
		#return false

func revoke_tokens() -> void:
	print("Revoking tokens ...")

	var headers = ["Content-Type: application/json"]

	var http_request = HTTPRequest.new()
	add_child(http_request)

	var data = {
		"token": token
	}

	var body = RequestBody.serialize("revoke_tokens", data)

	http_request.request(SERVER_ADDRESS, headers, HTTPClient.METHOD_POST, body)

	var response = await http_request.request_completed
	var response_body = JSON.parse_string(response[3].get_string_from_utf8())

	if response[1] == 200:
		print("Tokens revoked!")
	else:
		printerr("Token revocation failed!")

func update_tokens(_token, _refresh_token) -> void:
	token = _token
	refresh_token = _refresh_token
	save_tokens()

#region SAVE / LOAD
const SAVE_DIR = "user://token.dat"

func save_tokens():
	var file = FileAccess.open_encrypted_with_pass(SAVE_DIR, FileAccess.WRITE, "727")

	var tokens = {
		"token" : token,
		"refresh_token" : refresh_token
	}
	file.store_var(tokens)
	file.close()

func load_tokens():
	if FileAccess.file_exists(SAVE_DIR):
		var file = FileAccess.open_encrypted_with_pass(SAVE_DIR, FileAccess.READ, "727")
		var tokens = file.get_var()
		token = tokens["token"]
		refresh_token = tokens["refresh_token"]
		file.close()
	else:
		token = ""
		refresh_token = ""

func load_HTML(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var HTML = file.get_as_text().replace("    ", "\t").insert(0, "\n")
	file.close()

	return HTML
#endregion
