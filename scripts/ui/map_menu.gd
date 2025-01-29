extends Control

@onready var map_mode_button = %MapModeButton

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		_on_return_button_pressed()

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_start_button_pressed():
	MapManager.setup(map_mode_button.selected)
	get_tree().change_scene_to_file("res://scenes/ui/team_menu.tscn")
