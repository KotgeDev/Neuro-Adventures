extends Node
class_name OAuth

signal token_recieved

var PORT: int
var BINDING: String
var CLIENT_ID: String
var REDIRECT_URI: String
var AUTH_SERVER := "https://discord.com/oauth2/authorize" 
var API_ENDPOINT := "https://discord.com/api/v10"

var redirect_server := TCPServer.new() 

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

func _process(delta: float) -> void:
	if redirect_server.is_connection_available():
		var connection = redirect_server.take_connection()
		var request = connection.get_string(connection.get_available_bytes())
		if request:
			set_process(false)
			var auth_code = request.split(" HTTP")[0].split("=")[1]
			_get_token_from_auth(auth_code)
			
			connection.put_data(("HTTP/1.1 %d\r\n" % 200).to_ascii_buffer())
			connection.put_data(load_HTML("res://scripts/account/display_page.html").to_ascii_buffer())
			redirect_server.stop() 

func get_auth_code() -> void:
	set_process(true)
	
	var redir_err = redirect_server.listen(PORT, BINDING)
	
	var data = [
		"response_type=code",
		"client_id=%s" % CLIENT_ID,
		"scope=identify",
		"redirect_uri=%s" % REDIRECT_URI,
	]
	var body = "&".join(data)
	
	var url = AUTH_SERVER + "?" + body
	
	OS.shell_open(url)

func _get_token_from_auth(auth_code):
	print("Got auth code! Sending to server for accesss tokens ...  ")
	
	var headers = ["Content-Type: application/json"]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var data = {
		"auth_code": auth_code
	}
	
	var body = RequestBody.serialize("get_access_token", data)
	
	http_request.request(SERVER_ADDRESS, headers, HTTPClient.METHOD_POST, body)
	
	var response = await http_request.request_completed
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
