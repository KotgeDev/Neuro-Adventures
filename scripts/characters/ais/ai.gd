## Parent class for all ai
extends Node2D
class_name AI 

#region CONSTANTS
@export var MAX_SPEED := 65 
@export var ACCELERATION := 500
@export var FRICTION := 500 
@export var MAX_HEALTH := 45.0
#endregion 

#region NODES
@onready var search_field = $SearchField
@onready var character_animation = $CharacterAnimation
var collab_partner: CollabPartner
@onready var navigation_agent = $NavigationAgent2D
#endregion

#region OTHER 
@onready var health: float = MAX_HEALTH 
var velocity: Vector2 
#endregion 

func _ready() -> void:
	add_to_group("ai")
	connect_signals()

func connect_signals() -> void:
	Globals.map_ready.connect(_on_map_ready)
	Globals.damage_ai.connect(_on_hurtbox_take_damage)
	Globals.add_upgrade_to_ai.connect(_on_add_upgrade)
	
func _on_map_ready() -> void:
	collab_partner = get_tree().get_first_node_in_group("collab_partner")

func _collab_partner_get_pos() -> void: 
	navigation_agent.target_position = collab_partner.global_position

func _physics_process(delta: float) -> void:
	call_deferred("_collab_partner_get_pos")
	
	if collab_partner not in search_field.get_overlapping_bodies():
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
	
	position += velocity * delta 

func _on_hurtbox_take_damage(damage: float):
	damage = process_ai_damage_received(damage)
	if damage == 0.0:
		return 
	
	health -= damage 
	character_animation.show_damage()
	Globals.update_ai_health.emit(MAX_HEALTH, health)
	if health <= 0: 
		Globals.game_over.emit() 

func process_ai_damage_received(BASE_DAMAGE: float) -> float:
	var modified_damage := BASE_DAMAGE
	
	for upgrade in get_tree().get_nodes_in_group("process_ai_damage_received"):
		modified_damage = upgrade.process_ai_damage_received(BASE_DAMAGE, modified_damage) 

	return modified_damage

func _on_add_upgrade(upgrade: Node) -> void:
	add_child(upgrade)

