extends Control

const NO_SCORES_TEXT = "No scores available"
const LOADING_TEXT = "Loading..."
const FAILED_TEXT = "Failed to load.\nCheck internet connection"

@onready var score_panel_container = %ScorePanelContainer
@onready var score_panel = $ScorePanel
@onready var map_options_button = %MapOptionsButton
@onready var version_options_button = %VersionOptionsButton
@onready var loading_label = $LoadingLabel
@onready var metadata_loading = %MetadataLoading
@onready var title = %Title
@onready var login_button = %LoginButton
@onready var username_label = %UsernameLabel
@onready var score_description_panel = $ScoreDescriptionPanel
@onready var title_label = %TitleLabel
@onready var score_label = %ScoreLabel
@onready var lvl_label = %LvlLabel
@onready var time_label = %TimeLabel
@onready var ai_label = %AILabel
@onready var collab_label = %CollabLabel
@onready var login_panel = $LoginPanel



var metadata: Array 
var scores: Array 

func _ready() -> void:
	AccountManager.leaderboard_received.connect(_on_leaderboard_received)
	AccountManager.leaderboard_error.connect(_on_leaderboard_error)
	AccountManager.metadata_received.connect(_on_metadata_received)
	AccountManager.log_in_succesfull.connect(_on_log_in_successfull)
	AccountManager.log_out_succesfull.connect(_on_log_out_successfull)
	
	AccountManager.request_metadata.emit()
	
	if AccountManager.logged_in:
		set_user_details()
	else:
		remove_user_details()

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if score_description_panel.visible: 
			close_score_description() 
		if login_panel.visible:
			close_login_panel() 

func _on_metadata_received(_metadata: Array) -> void:
	metadata_loading.visible = false 
	metadata = _metadata
	
	map_options_button.clear() 
	version_options_button.clear() 
	
	for version in metadata:
		var version_as_int = int(version.versionNumber.replace('.', ''))
		version_options_button.add_item(version.versionNumber)
	
	var idx := 0 
	var current_version_idx := -1
	
	for version in metadata:
		if AccountManager.VERSION == version.versionNumber:
			current_version_idx = idx 
			for map in version.maps: 
				map_options_button.add_item(map)
		idx += 1

	version_options_button.select(current_version_idx)
	map_options_button.select(0)
	
	refresh()

func _on_leaderboard_error() -> void:
	loading_label.text = FAILED_TEXT 
	loading_label.visible = true  

func _on_leaderboard_received(leaderboard: Array) -> void:
	sort_leaderboard(leaderboard)
	
	if len(leaderboard) == 0:
		loading_label.text = NO_SCORES_TEXT
		loading_label.visible = true 
		scores = []
		return
	else:
		scores = leaderboard
		loading_label.visible = false 

	for data in leaderboard: 
		var new_panel = score_panel.duplicate()   
		
		var h_container = new_panel.get_node("HBoxContainer")
		var name_label = h_container.get_node("NameLabel")
		var score_label = h_container.get_node("ScoreLabel")
		var button = new_panel.get_node("ScorePanelButton")
		
		name_label.text = data.user 
		score_label.text = "| %s" % data.score
		new_panel.set_meta("uID", data.uID)
		
		new_panel.visible = true 
		score_panel_container.add_child(new_panel)
		
		button.pressed.connect(_on_score_panel_pressed.bind(data))

func _on_score_panel_pressed(data) -> void:
	title_label.text = data.user 
	score_label.text = "Score: %s" % data.score
	lvl_label.text = "Lvl: %s" % data.level
	time_label.text = "Time: %s" % data.time 
	ai_label.text = "AI: %s" % data.ai
	collab_label.text = "Collab: %s" % data.collabPartner 
	
	score_description_panel.visible = true 

func sort_leaderboard(leaderboard: Array) -> void: 
	leaderboard.sort_custom(score_compare) 

func score_compare(a, b) -> bool: 
	return int(a.score) > int(b.score)

func _on_version_options_button_item_selected(index):
	var version_name = version_options_button.get_item_text(index)
	var version_data 
	
	var previous_map_id = map_options_button.get_selected_id()
	map_options_button.clear() 
	
	for version in metadata:
		if version_name == version.versionNumber:
			version_data = version
			 
			for map in version.maps: 
				map_options_button.add_item(map)
	
	if len(version_data.maps) > previous_map_id: 
		map_options_button.select(previous_map_id)
	else:
		map_options_button.select(0)
	refresh() 

func _on_map_options_button_item_selected(index):
	refresh() 

func refresh() -> void:
	var version_text = version_options_button.get_item_text(version_options_button.get_selected_id())
	var map_text = map_options_button.get_item_text(map_options_button.get_selected_id())
	
	title.text = map_text
	loading_label.text = LOADING_TEXT
	loading_label.visible = true  	
	
	AccountManager.request_leaderboard.emit(version_text, map_text)
	for child in score_panel_container.get_children():
		child.queue_free() 

func _on_login_button_pressed():
	if AccountManager.logged_in: 
		AccountManager.request_log_out.emit() 
	else: 
		login_panel.visible = true 

func _on_log_in_successfull() -> void:
	close_login_panel()
	set_user_details() 

func _on_log_out_successfull() -> void:
	remove_user_details()

func set_user_details() -> void:
	username_label.text = "Logged in as %s  " % AccountManager.user_data.username
	login_button.text = "Log out"

func remove_user_details() -> void:
	username_label.text = "Log in to save scores  "
	login_button.text = "Log in"

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_your_score_checkbox_toggled(toggled_on):
	if toggled_on:
		for score_panel in score_panel_container.get_children():
			var id = score_panel.get_meta("uID") 
			if AccountManager.user_data.id == id: 
				score_panel.visible = true 
			else:
				score_panel.visible = false 
	else:
		for score_panel in score_panel_container.get_children():
			score_panel.visible = true 

func close_score_description():
	score_description_panel.visible = false 

func close_login_panel():
	login_panel.visible = false 

func _on_discord_login_button_pressed():
	AccountManager.request_log_in.emit() 
