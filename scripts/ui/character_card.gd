extends Control

signal selected(char: Globals.CharacterChoice)

@export var character: Globals.CharacterChoice

@onready var character_name = $CharacterName
@onready var ai_texture = $AITexture

func _ready() -> void:
	match character:
		Globals.CharacterChoice.NEURO:
			character_name.text = "Neuro"
		Globals.CharacterChoice.EVIL:
			character_name.text = "Evil"
		Globals.CharacterChoice.ANNY:
			ai_texture.hide() 
			character_name.text = "Anny"
		Globals.CharacterChoice.VEDAL:
			ai_texture.hide() 
			character_name.text = "Vedal"

func _on_selection_button_pressed():
	selected.emit(character) 
