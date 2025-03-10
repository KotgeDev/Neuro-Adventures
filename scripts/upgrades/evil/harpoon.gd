extends UpgradeScene

const GRACE_PERIOD := 1.5

@onready var enemy_search_area: Area2D = $EnemySearchArea
@onready var path_temp = preload("res://scenes/projectiles/ai_projectile_path.tscn")
@onready var harpoon_projectile = preload("res://scenes/projectiles/harpoon_projectile.tscn")
@onready var sfx: AudioStream = preload("res://assets/sfx/harpoonthrow.wav")
@onready var timer: AICooldownTimer = $AICooldownTimer
@onready var fire_pos: Marker2D = $Marker2D

var damage
var speed
var count
var pierce

func get_data() -> String:
	var data = (
		get_atk_str(damage) + "\n" +
		get_cd_str(timer.base_cooldown) + "\n" +
		get_general_str("Harpoons", count) + "\n" +
		get_pierce_str(pierce)
	)
	return data

func set_data(_damage: float, _speed: float, _count: int, _pierce: int, wait_time: float) -> void:
	if _damage: damage = _damage
	if _speed: speed = _speed
	if _count: count = _count
	if _pierce: pierce = _pierce
	if wait_time: timer.base_cooldown = wait_time

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_data(6.0, 700.0, 1, 6, 3.0)
		2:
			set_data(0, 0, 2, 0, 0)
		3:
			set_data(10.0, 0, 0, 0, 0)
		4:
			set_data(0, 0, 0, 0, 2.5)
		5:
			set_data(0, 0, 4, 100, 0)

func _on_ai_cooldown_timer_timeout() -> void:
	var areas = enemy_search_area.get_overlapping_areas()
	if areas.size() == 0:
		return

	areas.shuffle()

	for i in range(count):
		if areas.size() > i:
			set_harpoon_path(areas[i].global_position)

	await get_tree().create_timer(GRACE_PERIOD, false).timeout
	AudioSystem.play_sfx(sfx, global_position, 0.5)

func set_harpoon_path(target_pos: Vector2) -> void:
	var harpoon_path = path_temp.instantiate()
	harpoon_path.setup(damage, pierce, speed, GRACE_PERIOD, harpoon_projectile, sfx)
	add_child(harpoon_path)

	harpoon_path.look_at(target_pos)

	fire_pos.position = Vector2(27*cos(harpoon_path.global_rotation), 27*sin(harpoon_path.global_rotation))
	fire_pos.position.y += -16
	harpoon_path.global_position = fire_pos.global_position
