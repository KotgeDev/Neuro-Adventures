## Parent class for all ai
extends CharacterBody2D
class_name AI 

@export var collab_partner: CollabPartner

#region CONSTANTS
@export var MAX_SPEED := 65 
@export var ACCELERATION := 500
@export var FRICTION := 500 
@export var MAX_HEALTH := 45.0
#endregion 

#region NODES
@onready var search_field = $SearchField
@onready var marker_2d = $Marker2D
@onready var character_animation = $CharacterAnimation
#endregion

#region STATUS 
@onready var health: float = MAX_HEALTH 
#endregion 

func _ready() -> void:
	add_to_group("ai")
	connect_signals()

func connect_signals() -> void:
	Globals.map_ready.connect(setup)
	Globals.damage_ai.connect(_on_hurtbox_take_damage)
	Globals.add_upgrade_to_ai.connect(_on_add_upgrade)

## Called once map is ready 
## Override and add character-specific upgrades from here 
func setup() -> void:
	pass 

func _process(delta: float) -> void:
	if collab_partner not in search_field.get_overlapping_bodies():
		var target_pos = collab_partner.global_position 
		marker_2d.look_at(target_pos)
		velocity = velocity.move_toward(marker_2d.transform.x * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
	
	move_and_slide()

func _on_hurtbox_take_damage(damage: float):
	damage = process_damage_recieved(damage)
	if damage == 0.0:
		return 
	
	health -= damage 
	character_animation.show_damage()
	Globals.update_ai_health.emit(MAX_HEALTH, health)
	if health <= 0: 
		Globals.game_over.emit() 

func process_damage_recieved(BASE_DAMAGE: float) -> float:
	var modified_damage := BASE_DAMAGE
	
	modified_damage = process_damage_recieved_specific(BASE_DAMAGE, modified_damage)
	return modified_damage

## Override to add character specific damage processing 
func process_damage_recieved_specific(BASE_DAMAGE: float, modified_damage: float) -> float:
	return modified_damage

func apply_global_damage_modifiers(BASE_DAMAGE: float, modified_damage: float) -> float:	
	modified_damage = apply_global_damage_modifiers_specific(BASE_DAMAGE, modified_damage)
	return modified_damage 

## Override to add character specific damage processing 
func apply_global_damage_modifiers_specific(BASE_DAMAGE: float, modified_damage: float) -> float:
	return modified_damage 

func apply_ai_damage_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	var filter = get_node_or_null("Filter")
	if filter and area.get_parent() is CollabPartner: 
		match filter.upgrade.lvl: 
			1:
				modified_damage -= BASE_DAMAGE * 0.3 
			2:
				modified_damage -= BASE_DAMAGE * 0.4
			3:
				modified_damage -= BASE_DAMAGE * 0.5
			4:
				modified_damage -= BASE_DAMAGE * 0.7 
	
	modified_damage = apply_ai_damage_modifiers_specific(BASE_DAMAGE, modified_damage)
	return modified_damage
	
## Override to add character specific damage processing 
func apply_ai_damage_modifiers_specific(BASE_DAMAGE: float, modified_damage: float) -> float:
	return modified_damage

func _on_add_upgrade(upgrade: Node) -> void:
	add_child(upgrade)
