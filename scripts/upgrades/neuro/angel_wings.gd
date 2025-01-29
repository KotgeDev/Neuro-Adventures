extends UpgradeScene

const GRACE_PERIOD := 1.5

@onready var fire_timer = $FireTimer
@onready var enemy_search_area = $EnemySearchArea
@onready var ai = get_parent()
@onready var map = get_tree().get_first_node_in_group("map")
@onready var fire_pos: Marker2D = $Marker2D

var feather = preload("res://scenes/projectiles/feather.tscn")
var path_temp = preload("res://scenes/projectiles/ai_projectile_path.tscn")
var sfx: AudioStream = preload("res://assets/sfx/arrowswish.wav")

var damage: float
var speed: float
var pierce: int
var count: int
var sets: int

func set_data(
	_damage: float,
	_speed: float,
	_count: int,
	_pierce: int,
	wait_time: float,
	_sets: int
) -> void:
	if _damage: damage = _damage
	if _speed: speed = _speed
	if _count: count = _count
	if _pierce: pierce = _pierce
	if wait_time: fire_timer.base_cooldown = wait_time
	if _sets: sets = _sets

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_data(3.0, 300.0, 3, 2, 3.0, 1)
		2:
			set_data(0, 0, 5, 0, 0, 0)
		3:
			set_data(0, 0, 0, 0, 2.5, 0)
		4:
			set_data(4.0, 0, 7, 0, 0, 0)
		5:
			set_data(0, 0, 0, 0, 0, 2)


const DEG = 10.0

func _on_fire_timer_timeout():
	var areas = enemy_search_area.get_overlapping_areas()
	if areas.size() == 0:
		return

	areas.shuffle()

	for i in range(sets):
		if areas.size() > i:
			var current_count = count
			var pos = areas[i].global_position
			for j in range((current_count-1)/2):
				set_feather_path(pos, deg_to_rad(-DEG*(j+1)))
			set_feather_path(pos)
			for j in range((current_count-1)/2):
				set_feather_path(pos, deg_to_rad(DEG*(j+1)))

	await get_tree().create_timer(GRACE_PERIOD, false).timeout
	AudioSystem.play_sfx(sfx, global_position)

func set_feather_path(target_pos: Vector2, angle := 0.0) -> void:
	var feather_path = path_temp.instantiate()
	feather_path.setup(damage, pierce, speed, GRACE_PERIOD, feather, sfx)
	add_child(feather_path)

	feather_path.look_at(target_pos)
	feather_path.rotation += angle

	fire_pos.position = Vector2(24*cos(feather_path.global_rotation), 24*sin(feather_path.global_rotation))
	fire_pos.position.y += -16
	feather_path.global_position = fire_pos.global_position
