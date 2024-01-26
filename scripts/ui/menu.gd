extends Control

@onready var options_menu = $OptionsMenu
@onready var v_box_container = $VBoxContainer

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/farm.tscn")

func _on_option_button_pressed():
	options_menu.visible = true 
	v_box_container.visible = false 

func _on_options_close_options():
	v_box_container.visible = true 

func _on_quit_button_pressed():
	get_tree().quit() 


