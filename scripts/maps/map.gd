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
var vedal_template = preload("res://scenes/characters/collab_partners/vedal.tscn")
var anny_template = preload("res://scenes/characters/collab_partners/anny.tscn")
#endregion 

#region ACHIEVEMENT RELATED
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

const AI_POS = Vector2(1217, 322)
const COLLAB_POS = Vector2(1276, 331)

func _ready() -> void:
	Globals.add_collectible_generator.connect(_on_add_collectible_generator)
	
	match SavedOptions.settings.ai_selected:
		SavedOptions.AISelection.NEURO:
			ai_scene = neuro_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = AI_POS
		SavedOptions.AISelection.EVIL:
			ai_scene = evil_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = AI_POS
		
	match SavedOptions.settings.collab_partner_selected:
		SavedOptions.CollabPartnerSelection.VEDAL:
			collab_scene = vedal_template.instantiate()
			add_child(collab_scene)
			collab_scene.global_position = COLLAB_POS 
		SavedOptions.CollabPartnerSelection.ANNY:
			collab_scene = anny_template.instantiate()
			add_child(collab_scene)
			collab_scene.global_position = COLLAB_POS  
	
	add_to_group("map")
	Globals.map_ready.emit() 
	spawn_enemies()

func _on_add_collectible_generator(generator: CollectibleGenerator) -> void:
	collectible_generators.append(generator) 

## Override function to use
func spawn_enemies() -> void:
	pass 


