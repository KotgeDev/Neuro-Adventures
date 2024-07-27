extends Control

@onready var options_menu = %OptionsMenu
@onready var achievements_menu = %AchievementsMenu
@onready var credits_menu = %CreditsMenu
@onready var announcements = %Announcements

@onready var v_box_container = $VBoxContainer

var menu_song = preload("res://assets/songs/themeadow.wav")

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	if AudioSystem.music_player.stream != menu_song:
		AudioSystem.play_music(menu_song)
		
	options_menu.close_panel.connect(_on_close)
	credits_menu.close_panel.connect(_on_close)
	achievements_menu.close_panel.connect(_on_close)
	announcements.close_panel.connect(_on_close)

#region BUTTONS 
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/map_menu.tscn")

func _on_characters_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/characters_menu.tscn")

func _on_credits_button_pressed():
	credits_menu.visible = true 
	v_box_container.visible = false 

func _on_quit_button_pressed(): 
	get_tree().quit()
#endregion 

#region ICONS 
func _on_settings_icon_pressed():
	options_menu.visible = true 
	v_box_container.visible = false 

func _on_acheivements_icon_pressed():
	achievements_menu.visible = true 
	v_box_container.visible = false 
	
func _on_announcement_icon_pressed():
	announcements.visible = true 
	v_box_container.visible = false 
#endregion 

func _on_close() -> void:
	v_box_container.visible = true 




