extends Drone
class_name Pizza

@export var BASE_ROTATION_SPEED := 3

#region NODES
@onready var ai_search_field = $AISearchField
@onready var enemy_search_field = $EnemySearchField
@onready var compass = $Compass
@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var multi_hitbox = $MultiHitbox
@onready var pizza_personal_zone = $PizzaPersonalZone
@onready var map = get_tree().get_first_node_in_group("map") as MAP
@onready var sprite_2d = $Sprite2D
#endregion

#region OTHER
var velocity: Vector2
var target: Node = null
var id: int
var collab_partner_in_range := false
var max_rotate_speed
var rotate_speed := 0.0
#endregion

func ready():
	reparent(map)

	id = randi() % (1 << 31)

	Globals.update_pizza.emit()

func _process(delta: float) -> void:
	# Target enemy if one exists
	var targeting_enemy = search_and_target_enemy(delta)
	# If not targeting and ai is not within range, go to ai
	if not targeting_enemy and not ai_within_range():
		max_rotate_speed = BASE_ROTATION_SPEED
		goto_ai(delta)

	# Ensure drones are not too close to each other
	for area in pizza_personal_zone.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Pizza:
			if id > parent.id:
				velocity = velocity.move_toward(compass.transform.y * max_speed, ACCELERATION * delta)
			else:
				velocity = velocity.move_toward( -1 * compass.transform.y * max_speed, ACCELERATION * delta)

	# Rotate pizza according to set max rotate speed
	if abs(rotate_speed - max_rotate_speed) < 1:
		pass
	elif rotate_speed < max_rotate_speed:
		rotate_speed += 3 * delta
	elif rotate_speed > max_rotate_speed:
		rotate_speed -= 3 * delta
	sprite_2d.rotate(rotate_speed * delta)

	position += velocity * delta

func goto_ai(delta: float) -> void:
	var target_pos = ai.global_position
	compass.look_at(target_pos)
	velocity = velocity.move_toward(compass.transform.x * max_speed, ACCELERATION * delta)

## Searches and targets an enemy.
## Returns false if no enemies are targeted and there are no
## enemies within range to target
func search_and_target_enemy(delta: float) -> bool:
	if target and is_instance_valid(target):
		if target in multi_hitbox.get_overlapping_areas():
			velocity = velocity.move_toward(compass.transform.x * max_speed, ACCELERATION * delta)
			max_rotate_speed = BASE_ROTATION_SPEED * 3.0
		else:
			max_rotate_speed = BASE_ROTATION_SPEED * 2.5
			var target_pos = target.global_position
			compass.look_at(target_pos)
			velocity = velocity.move_toward(compass.transform.x * max_speed, ACCELERATION * delta)
		return true

	max_rotate_speed = BASE_ROTATION_SPEED
	var closest_enemy = null
	var first_iter = true
	for area in enemy_search_field.get_overlapping_areas():
		if area.owned_by == Globals.Owners.OWNED_BY_ENEMY:
			if first_iter:
				first_iter = false
				closest_enemy = area
			else:
				var closest_enemy_distance = abs((closest_enemy.global_position - ai.global_position).length())
				var current_enemy_distance = abs((area.global_position - ai.global_position).length())

				if current_enemy_distance < closest_enemy_distance:
					closest_enemy = area

	if closest_enemy:
		target = closest_enemy
		var target_pos = closest_enemy.global_position
		compass.look_at(target_pos)
		velocity = velocity.move_toward(compass.transform.x * max_speed, ACCELERATION * delta)

	return false

func ai_within_range() -> bool:
	for area in ai_search_field.get_overlapping_areas():
		if area.owned_by == Globals.Owners.OWNED_BY_AI:
			return true
	return false
