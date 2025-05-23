extends Control
class_name CharacterCard

signal selected(char: Globals.CharacterChoice)
## For Team Character Scrolling
signal selected_t(card: CharacterCard)

@export var character: Globals.CharacterChoice
## For Team Character Scrolling
@export var id: int

@onready var character_name = %CharacterName
@onready var ai_texture = %AITexture

var data: CharacterData

func _ready() -> void:
	data = CharacterManager.character_data[character]

	character_name.text = data.character_name
	if not data.is_ai:
		ai_texture.hide()

func _on_selection_button_pressed():
	selected.emit(character)
	selected_t.emit(self)
