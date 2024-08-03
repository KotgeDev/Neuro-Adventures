extends Control

@export var pause_manager: Control

@onready var victory_label = $VictoryLabel
@onready var sprite = $Sprite
@onready var score_label = %ScoreLabel
@onready var time_label = %TimeLabel
@onready var mode_label = %ModeLabel
@onready var ai_label = %AILabel
@onready var collab_label = %CollabLabel
@onready var animation_player = $AnimationPlayer
@onready var quote = $Quote

func display_victory() -> void:
	_display()
	
func display_game_over() -> void:
	if MapManager.map_mode == MapManager.MapMode.ENDLESS:
		victory_label.text = "Endless Mode"
		score_label.text = "SCORE: %d" % get_tree().get_first_node_in_group("map").score 
		score_label.visible = true 
	else: 
		victory_label.text = "Game Over ... "
		sprite.visible = false 
		victory_label.set_material(null)
		quote.text = "Someone tell Vedal there is a problem with my AI"
	
	_display()

func _display() -> void:
	animation_player.play("anim") 
	mode_label.text = "Map: The Farm [%s]" %  MapManager.MapMode.keys()[MapManager.map_mode].to_lower().capitalize()
	time_label.text = "Elapsed Time: %s" % pause_manager.get_elapsed_time() 
	ai_label.text = "AI: %s" % CharacterDataManager.character_data[SavedOptions.settings.ai_selected].character_name
	collab_label.text = "Collab Partner: %s" % CharacterDataManager.character_data[SavedOptions.settings.collab_partner_selected].character_name	

func _on_menu_button_pressed():
	AudioSystem.end_music()
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

