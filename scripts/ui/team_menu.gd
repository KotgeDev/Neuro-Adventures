extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/farm.tscn")

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/map_menu.tscn")
