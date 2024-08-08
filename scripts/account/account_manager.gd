extends Node

@onready var http_request = HTTPRequest.new()

var config: ConfigFile

var version: String
var address: String
var password: String

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	config = _load_config_file("res://config/prod.cfg")
	version = config.get_value("server", "version")
	address = config.get_value("server", "address")
	password = config.get_value("server", "password")
	
	get_leaderboard()

func get_leaderboard() -> void:
	print("Requesting leaderboard data from ", config.get_value("server", "address"))
	http_request.request(address)
	
func send_score(score: int, map: int) -> void:
	pass 

func _on_request_completed(result, response_code, headers, body) -> void:
	#var json = JSON.parse_string(body.get_string_from_utf8())
	print("Leaderboard received!")
	print("Data is: ", body.get_string_from_utf8())

func _load_config_file(filename: String) -> Variant:
	var file: ConfigFile = ConfigFile.new()

	var err: Error = file.load(filename)
	assert(err != Error.ERR_FILE_NOT_FOUND, "Cannot find the config file %s" % filename)

	if err != OK:
		printerr("Failed to load config file %s, error %d" % [filename, err])
		return null

	return file
