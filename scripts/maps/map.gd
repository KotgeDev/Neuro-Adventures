extends Node2D
class_name MAP

const AI_POS = Vector2(1217, 322)
const COLLAB_POS = Vector2(1276, 331)

#region NTX
@export var BASE_NTX_CHANCE := 0.4
@export var NTX_REQ := 50
@export var PITY_REQ := 300 
@export var PITY_STEP := 0.1

var enemies_killed_since_last_ntx := 0
var ntx_chance := 0.2
#endregion 

#region CHARACTER TEMPLATES
var neuro_template = preload("res://scenes/characters/ais/neuro.tscn")
var evil_template = preload("res://scenes/characters/ais/evil.tscn") 
var vedal_template = preload("res://scenes/characters/collab_partners/vedal.tscn")
var anny_template = preload("res://scenes/characters/collab_partners/anny.tscn")
#endregion 

#region ACHIEVEMENT CONDITIONS 
var gymbag_drone_count := 0
var swarm_max := false 
var raise_the_timer := false 
var say_it_back_max := false 
var dual_strike_max := false 
#endregion

#region OTHER
var collectible_generators = []
var ai_scene 
var collab_scene 
#endregion

#region ENDLESS MODE 
var scaling_difficulty = 1.0 
var scale_factor = 1.0 
var score = 0
#endregion 

func _ready() -> void:
	Globals.add_collectible_generator.connect(_on_add_collectible_generator)
	Globals.enemy_killed.connect(_on_enemy_killed)
	
	match SettingsManager.settings.ai_selected:
		Globals.CharacterChoice.NEURO:
			ai_scene = neuro_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = AI_POS
		Globals.CharacterChoice.EVIL:
			ai_scene = evil_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = AI_POS
		
	match SettingsManager.settings.collab_partner_selected:
		Globals.CharacterChoice.VEDAL:
			collab_scene = vedal_template.instantiate()
			add_child(collab_scene)
			collab_scene.global_position = COLLAB_POS 
		Globals.CharacterChoice.ANNY:
			collab_scene = anny_template.instantiate()
			add_child(collab_scene)
			collab_scene.global_position = COLLAB_POS
			
	StatsManager.reset()
	
	add_to_group(Globals.MAP_GROUP_NAME)
	Globals.map_ready.emit() 
	
	if MapManager.map_mode == MapManager.MapMode.ENDLESS:
		spawn_enemies_endless()
	else:
		spawn_enemies()

func _on_add_collectible_generator(generator: CollectibleGenerator) -> void:
	collectible_generators.append(generator) 

func _on_enemy_killed(value: int) -> void:
	score += value 

## Override function to use
func spawn_enemies() -> void:
	pass 

## Override function to use
func spawn_enemies_endless() -> void:
	pass 
