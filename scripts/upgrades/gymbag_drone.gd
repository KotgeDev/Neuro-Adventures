extends UpgradeScene
class_name GymbagDrone 

@export_category("Gymbag Drone")
@export var MAX_SPEED := 40
@export var ACCELERATION := 100
@export var DAMAGE := 1 

#region NODES
@onready var animation_player = $AnimationPlayer
@onready var ai_search_field = $AISearchField
@onready var enemy_search_field = $EnemySearchField
@onready var compass = $Compass
@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var multi_hitbox = $MultiHitbox
@onready var gymbag_drone_personal_zone = $GymbagDronePersonalZone
@onready var map = get_tree().get_first_node_in_group("map")
#endregion 

var velocity: Vector2
## Targeted Enemy's Hurtbox 
var target: Node = null 
var id: int 

func _ready():
	reparent(map)
	
	$MultiHitbox.damage = DAMAGE
	id = randi() % (1 << 31)
	upgrade.lvl -= 1 
	animation_player.play("idle")	

func _process(delta: float) -> void:
	if not search_and_target_enemy(delta) and not ai_within_range(delta):	
		var target_pos = ai.global_position
		compass.look_at(target_pos)
		velocity = velocity.move_toward(compass.transform.x * MAX_SPEED, ACCELERATION * delta)
	
	for area in gymbag_drone_personal_zone.get_overlapping_areas():
		var parent = area.get_parent() 
		if parent is GymbagDrone:
			if id > parent.id: 
				velocity = velocity.move_toward(compass.transform.y * MAX_SPEED, ACCELERATION * delta)
			else: 
				velocity = velocity.move_toward( -1 * compass.transform.y * MAX_SPEED, ACCELERATION * delta)
			
	position += velocity * delta 

## Searches and targets an enemy. 
## Returns false if no enemies are targeted and there are no 
## enemies within range to target 
func search_and_target_enemy(delta: float) -> bool: 
	if target and is_instance_valid(target): 
		if target in multi_hitbox.get_overlapping_areas():
			velocity = velocity.move_toward(compass.transform.x * MAX_SPEED, ACCELERATION * delta) 
		else:
			var target_pos = target.global_position 
			compass.look_at(target_pos) 
			velocity = velocity.move_toward(compass.transform.x * MAX_SPEED, ACCELERATION * delta)
		return true 
	
	for area in enemy_search_field.get_overlapping_areas():
		if area.owned_by == Globals.Owners.OWNED_BY_ENEMY:
			target = area
			var target_pos = area.global_position 
			compass.look_at(target_pos) 
			velocity = velocity.move_toward(compass.transform.x * MAX_SPEED, ACCELERATION * delta)
			return true	
			
	return false 

func ai_within_range(delta: float) -> bool:
	for area in ai_search_field.get_overlapping_areas():
		if area.owned_by == Globals.Owners.OWNED_BY_AI:
			return true 
	return false 
