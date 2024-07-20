extends Control

signal selected(char: Globals.CharacterChoice)

@export var character: Globals.CharacterChoice

@onready var character_name = %CharacterName
@onready var ai_texture = %AITexture

var data: CharacterData

func _ready() -> void:
	data = CharacterDataManager.character_data[character]
	
	character_name.text = data.character_name 
	if not data.is_ai: 
		ai_texture.hide() 
	
func _on_selection_button_pressed():
	selected.emit(character) 
