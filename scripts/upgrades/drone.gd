extends UpgradeScene
class_name Drone

@export var BASE_MAX_SPEED := 40.0
@export var ACCELERATION := 100.0
@export var BASE_DAMAGE := 1.0

@export var hitbox: MultiHitbox

var max_speed: float :
	get() :
		return max_speed * (1.0 + StatsManager.drone_spd_inc)

func get_data() -> String:
	var data = (
		get_atk_str(BASE_DAMAGE) + "\n" +
		get_general_str("Speed", max_speed * (1.0 + StatsManager.drone_spd_inc))
	)
	return data

func _ready() -> void:
	set_stats(BASE_MAX_SPEED, BASE_DAMAGE)
	add_to_group("drone")
	StatsManager.drone_count += 1
	ready()

func set_stats(_speed, _damage) -> void:
	max_speed = _speed
	hitbox.damage = _damage

## Override to use
func ready() -> void:
	pass

func _on_update_drone_speed() -> void:
	pass
