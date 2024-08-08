extends Control

@onready var ai_sprite = %AISprite
@onready var ai_description = %AIDescription
@onready var collab_sprite = %CollabSprite
@onready var collab_description = %CollabDescription

var ai_selection = Globals.CharacterChoice.NEURO 
var collab_selection = Globals.CharacterChoice.VEDAL

var neuro_texture: Texture2D = preload("res://assets/characters/ais/neuro_idle_sheet.png")
var evil_texture: Texture2D = preload("res://assets/characters/ais/evil_idle_sheet.png")
var vedal_texture: Texture2D = preload("res://assets/characters/collab_partners/vedal_idle_sheet.png")
var anny_texture: Texture2D = preload("res://assets/characters/collab_partners/anny_idle_sheet.png")

var neuro_description = """Neuro Sama
HP: 45
Speed: 60
Starting Weapon: Dual Strike - Neuro wields dual swords she bought during the Snuffy D&D Collab.
"""
var evil_description = """Evil Neuro
HP: 60
Speed: 50
Starting Weapon: Knife - Evil wields a knife that deals consecutive damage to any enemy in range.
"""
var vedal_description = """Vedal
HP: 40
Speed: 80
Starting Weapon: Rum - Vedal will throw his rum at the enemies, creating a splash. Enemies encountering the splash will be intoxicated (stunned) for a while.
Starting Ability: DM Allegations - Vedal will become imune for 0.4s if [space] is pressed, with a cooldown of 5s. A pink notification above Vedal means that the ability is charged. 
"""
var anny_description = """Anny
HP: 
Speed: 
Starting Weapon: Star - 
Starting Ability: Portal - 
"""

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	ai_selection = SettingsManager.settings.ai_selected 
	collab_selection = SettingsManager.settings.collab_partner_selected
	set_selection()

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

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

func _on_collab_selection_button_pressed():
	if collab_selection == 1:
		collab_selection = 0 
	else:
		collab_selection += 1 
		
	set_selection() 

func _on_collab_selection_button_back_pressed():
	if collab_selection == 0:
		collab_selection = 1 
	else:
		collab_selection -= 1 
	
	set_selection() 

func set_selection() -> void:
	match ai_selection:
		Globals.CharacterChoice.NEURO:
			SettingsManager.settings.ai_selected = Globals.CharacterChoice.NEURO
			ai_sprite.texture = neuro_texture 
			ai_description.text = neuro_description
		Globals.CharacterChoice.EVIL:
			SettingsManager.settings.ai_selected = Globals.CharacterChoice.EVIL
			ai_sprite.texture = evil_texture
			ai_description.text = evil_description
	match collab_selection:
		Globals.CharacterChoice.VEDAL:
			SettingsManager.settings.collab_partner_selected = Globals.CharacterChoice.VEDAL
			collab_sprite.texture = vedal_texture 
			collab_description.text = vedal_description
		Globals.CharacterChoice.ANNY:
			SettingsManager.settings.collab_partner_selected = Globals.CharacterChoice.ANNY
			collab_sprite.texture = anny_texture
			collab_description.text = anny_description

	SettingsManager.save_settings.emit() 
