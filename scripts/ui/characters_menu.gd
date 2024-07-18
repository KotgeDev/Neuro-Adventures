extends Control

func _on_character_display_selected(char):
	match char: 
		Globals.CharacterChoice.NEURO:
			get_tree().change_scene_to_file("res://scenes/ui/character_displayer.tscn") 

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

