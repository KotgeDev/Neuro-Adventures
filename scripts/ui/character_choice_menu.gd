extends Control

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/farm.tscn")

func _on_ai_selection_button_pressed():
	$VBoxContainer/HBoxContainer/Panel/Neuro.visible = false
	$VBoxContainer/HBoxContainer/Panel/Evil.visible = true 
	$VBoxContainer/HBoxContainer/Panel/AISelectionButton.disabled = true 
