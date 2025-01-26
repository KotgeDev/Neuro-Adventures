extends Drone
class_name GymbagDrone

@export_category("Gymbag Drone")
@export var BASE_MAX_SPEED := 40.0
@export var ACCELERATION := 100.0
@export var BASE_DAMAGE := 1.0

#region NODES
@onready var animation_player = $AnimationPlayer
@onready var ai_search_field = $AISearchField
@onready var enemy_search_field = $EnemySearchField
@onready var compass = $Compass
@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var multi_hitbox = $MultiHitbox
@onready var gymbag_drone_personal_zone = $GymbagDronePersonalZone
@onready var map = get_tree().get_first_node_in_group("map") as MAP
@onready var battery_timer = $BatteryTimer
#endregion

#region SOUNDFX
var buzz_sfx: AudioStream = preload("res://assets/sfx/dronebzzz.wav")
#endregion

#region OTHER
var velocity: Vector2
var target: Node = null
var id: int
var collab_partner_in_range := false
var need_recharge := false
@onready var max_speed: float = BASE_MAX_SPEED
#endregion

func _ready():
	map.gymbag_drone_count += 1
	reparent(map)

	set_damage(BASE_DAMAGE)
	id = randi() % (1 << 31)
	upgrade.lvl -= 1
	animation_player.play("idle")

	Globals.update_drones.emit()

func set_damage(damage: float) -> void:
	$MultiHitbox.damage = damage

func _process(delta: float) -> void:
	if need_recharge:
		if ai_within_range():
			battery_timer.start()
			need_recharge = false
		else:
			goto_ai(delta)
	else:
		# Target enemy if one exists
		var targeting_enemy = search_and_target_enemy(delta)
		# If not targeting and ai is not within range, go to ai
		if not targeting_enemy and not ai_within_range():
			goto_ai(delta)

	# Ensure drones are not too close to each other
	for area in gymbag_drone_personal_zone.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is GymbagDrone:
			if id > parent.id:
				velocity = velocity.move_toward(compass.transform.y * max_speed, ACCELERATION * delta)
			else:
				velocity = velocity.move_toward( -1 * compass.transform.y * max_speed, ACCELERATION * delta)

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
		else:
			var target_pos = target.global_position
			compass.look_at(target_pos)
			velocity = velocity.move_toward(compass.transform.x * max_speed, ACCELERATION * delta)
		return true

	for area in enemy_search_field.get_overlapping_areas():
		if area.owned_by == Globals.Owners.OWNED_BY_ENEMY:
			target = area
			var target_pos = area.global_position
			compass.look_at(target_pos)
			velocity = velocity.move_toward(compass.transform.x * max_speed, ACCELERATION * delta)
			return true

	return false

func ai_within_range() -> bool:
	for area in ai_search_field.get_overlapping_areas():
		if area.owned_by == Globals.Owners.OWNED_BY_AI:
			return true
	return false

func _on_ai_search_field_area_entered(area):
	if area.owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		AudioSystem.play_sfx(buzz_sfx, global_position, 5.0)

func _on_battery_timer_timeout():
	battery_timer.stop()
	need_recharge = true
