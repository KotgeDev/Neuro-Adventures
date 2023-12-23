extends Control
@onready var pause_menu = $PauseMenu
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/farm.tscn")

func _on_quit_button_pressed():
	get_tree().quit() 

func _on_option_button_pressed():
	pause_menu.visible = true
	
func _on_exit_pause_menu_button_pressed():
	pause_menu.visible = false
