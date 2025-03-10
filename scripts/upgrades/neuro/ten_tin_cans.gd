extends UpgradeScene

var bullet_temp = preload("res://scenes/projectiles/bullet.tscn")
@onready var timer: AICooldownTimer = $AICooldownTimer
@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME) as MAP
@onready var fire_position: Marker2D = $FirePosition
@onready var sfx: AudioStream = preload("res://assets/sfx/reallygunpull.wav")

var speed := 0.0
var damage := 0.0
var projectile_count := 0
var timeout := 0.0
var pierce := 0

func get_data() -> String:
	var data = (
		get_atk_str(damage) + "\n" +
		get_cd_str(timer.base_cooldown) + "\n" +
		get_general_str("Bullets", projectile_count) + "\n" +
		get_pierce_str(pierce)
	)
	return data

func setup(count: int, wait_time: float, _damage: float, _speed: float, _pierce: int) -> void:
	if count: projectile_count = count
	if wait_time: timer.base_cooldown = wait_time
	if _damage: damage = _damage
	if _speed: speed = _speed
	if _pierce: pierce = _pierce

	timeout = 2500.0 / speed

func sync_level() -> void:
	match upgrade.lvl:
		1:
			setup(6, 3.0, 1.0, 250.0, 2)
		2:
			setup(8, 0, 0, 0, 3)
		3:
			setup(0, 0, 3, 0, 0)
		4:
			setup(10, 0, 0, 0, 4)
		5:
			setup(0, 2.5, 0, 0, 0)
		6:
			setup(18, 0, 0, 0, 0)

func shoot() -> void:
	var mouse_pos = get_global_mouse_position()

	fire_position.position = (mouse_pos - global_position).normalized() * 17.0
	fire_position.position.y -= 15.0

	var new_bullet = bullet_temp.instantiate()
	# Speed, Damage, Timeout
	new_bullet.set_up(speed, damage, timeout, pierce)
	map.add_child(new_bullet)
	fire_position.look_at(mouse_pos)
	new_bullet.rotation = fire_position.rotation
	new_bullet.global_position = fire_position.global_position

	AudioSystem.play_sfx(sfx, fire_position.global_position, 0.3)

func _on_ai_cooldown_timer_timeout() -> void:
	for i in range(projectile_count):
		shoot()
		await get_tree().create_timer(0.1, false).timeout
