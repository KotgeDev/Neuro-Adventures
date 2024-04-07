extends Node2D
class_name MAP

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
#endregion 

#region ACHIEVEMENT RELATED
var gymbag_drone_count := 0
var swarm_max := false 
var raise_the_timer := false 
var say_it_back_max := false 
var dual_strike_max := false 
#endregion

var ai_scene 

func _ready() -> void:
	match SavedOptions.settings.ai_selected:
		SavedOptions.AISelection.NEURO:
			ai_scene = neuro_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = Vector2(1217, 322)
		SavedOptions.AISelection.EVIL:
			ai_scene = evil_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = Vector2(1217, 322)
	
	add_to_group("map")
	Globals.map_ready.emit() 
	spawn_enemies()

func spawn_enemies() -> void:
	pass 
