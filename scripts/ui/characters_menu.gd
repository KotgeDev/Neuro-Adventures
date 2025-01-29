extends Control

var character_selected := false

func _process(delta):
	if Input.is_action_just_pressed("menu") and not character_selected:
		_on_return_button_pressed()

func _on_character_display_selected(char):
	character_selected = true
	CharacterDisplayer.create(self, char)

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_close() -> void:
	character_selected = false
