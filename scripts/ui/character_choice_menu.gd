extends Control

@onready var ai_sprite = %AISprite
@onready var ai_description = %AIDescription

var ai_selection = SavedOptions.AISelection.NEURO 

var neuro_texture: Texture2D = preload("res://assets/characters/ais/neuro_idle_sheet.png")
var neuro_description = "Neuro Sama\nHP: 45\nSpeed: 60\nStarting Weapon: Neuro wields dual swords she bought during the Snuffy D&D Collab.\n\"Filtered.\" - Neuro Sama"
var evil_texture: Texture2D = preload("res://assets/characters/ais/evil_idle_sheet.png")
var evil_description = "Evil Neuro\nHP: 60\nSpeed: 50\nStarting Weapon: Evil wields a knife that deals consecutive damage to any enemy in range.\n\"Viva la Pizza Revolution!\" - Evil Neuro"

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	ai_selection = SavedOptions.settings.ai_selected 
	set_selection()

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/farm.tscn")

func _on_ai_selection_button_pressed():
	if ai_selection == 1:
		ai_selection = 0 
	else:
		ai_selection += 1 
		
	set_selection() 

func _on_ai_selection_button_back_pressed():
	if ai_selection == 0:
		ai_selection = 1 
	else:
		ai_selection -= 1 
	
	set_selection() 

func set_selection() -> void:
	match ai_selection:
		SavedOptions.AISelection.NEURO:
			SavedOptions.settings.ai_selected = SavedOptions.AISelection.NEURO
			SavedOptions.save_settings.emit() 
			ai_sprite.texture = neuro_texture 
			ai_description.text = neuro_description
		SavedOptions.AISelection.EVIL:
			SavedOptions.settings.ai_selected = SavedOptions.AISelection.EVIL
			SavedOptions.save_settings.emit() 
			ai_sprite.texture = evil_texture
			ai_description.text = evil_description


