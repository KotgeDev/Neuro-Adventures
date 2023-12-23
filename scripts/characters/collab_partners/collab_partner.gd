## Parent class for all collab partners
extends CharacterBody2D
class_name CollabPartner  

#region CONSTANTS 
@export var BASE_MAX_SPEED := 80.0 
@export var ACCELERATION := 500.0
@export var FRICTION := 500.0 
@export var MAX_HEALTH := 50.0 
@export var EXP_REQ_INCREMENT := 5
@export var EXP_REQ_INIT := 2
#endregion 

#region NODES 
@onready var character_animation = $CharacterAnimation
@onready var collectionbox = $Collectionbox
#endregion 

#region OTHER 
@onready var max_speed: float = BASE_MAX_SPEED
@onready var health: float = MAX_HEALTH
var expp := 0
var exp_requirement := EXP_REQ_INIT
var lv := 1  
#endregion

func _ready() -> void:
	add_to_group("collab_partner")
	connect_signals() 

func connect_signals() -> void: 
	Globals.map_ready.connect(setup)
	Globals.damage_collab_partner.connect(_on_hurtbox_take_damage)
	Globals.add_upgrade_to_collab_partner.connect(_on_add_upgrade)
	collectionbox.area_entered.connect(_on_collectionbox_area_entered)

## Called once map is ready 
## Override and add character-specific upgrades from here 
func setup() -> void:
	pass 

func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	
	if input_vector != Vector2.ZERO: 
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

func _on_hurtbox_take_damage(damage: float):
	damage = process_damage_recieved(damage)
	if damage == 0.0:
		return 
	
	health -= damage 
	character_animation.show_damage()
	Globals.update_collab_partner_health.emit(MAX_HEALTH, health)
	if health <= 0: 
		Globals.game_over.emit() 

func _on_collectionbox_area_entered(area):
	expp += 1 
	if expp >= exp_requirement: 
		expp = 0 
		exp_requirement += EXP_REQ_INCREMENT
		lv += 1
		Globals.get_random_upgrades.emit()
	Globals.update_exp_bar.emit(exp_requirement, expp) 
	area.queue_free() 

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

func apply_collab_damage_modifiers(BASE_DAMAGE: float, modified_damage: float) -> float:
	modified_damage = apply_collab_damage_modifiers_specific(BASE_DAMAGE, modified_damage)
	return modified_damage
	
## Override to add character specific damage processing 
func apply_collab_damage_modifiers_specific(BASE_DAMAGE: float, modified_damage: float) -> float:
	return modified_damage

func _on_add_upgrade(upgrade: Node) -> void:
	add_child(upgrade)
