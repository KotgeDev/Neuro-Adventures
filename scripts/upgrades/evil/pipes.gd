extends UpgradeScene

const GRACE_PERIOD := 1.5
const MAX_RANGE := 100.0

@onready var enemy_search_area = $EnemySearchArea
@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME)
@onready var timer: AICooldownTimer = $AICooldownTimer

var pipe_temp: PackedScene = preload("res://scenes/projectiles/pipe.tscn")
var warning_temp: PackedScene = preload("res://scenes/projectiles/pipe_warning.tscn")
var pipe_sfx: AudioStream = preload("res://assets/sfx/metalpipe5.wav")

var damage: float
var count: int
var pipe_count := 10

func set_stats(
	_damage: float,
	_count: int,
	_pipe_count: int,
	wait_time: float
) -> void:
	if _damage: damage = _damage
	if _count: count = _count
	if _pipe_count: pipe_count = _pipe_count
	if wait_time: timer.base_cooldown = wait_time

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_stats(5.0, 1, 8, 5.0)
		2:
			set_stats(0, 0, 0, 4.0)
		3:
			set_stats(0, 2, 0, 0)
		4:
			set_stats(0, 2, 12, 0)
		5:
			set_stats(10.0, 0, 0, 0)
		6:
			set_stats(0, 4, 0, 0)

func _on_ai_cooldown_timer_timeout():
	var enemies := []

	for enemy in enemy_search_area.get_overlapping_areas():
		enemies.append(enemy.global_position)
	enemies.shuffle()

	for i in range(count):
		if enemies.size() > i:
			drop_pipes(enemies[i])

func drop_pipes(enemy_pos: Vector2) -> void:
	var current_pipe_count = pipe_count

	var positions = []
	var warnings = []
	var pipes = []

	for i in range(current_pipe_count):
		var radians = randf_range(0, TAU)
		var length = randi_range(0, MAX_RANGE)
		var new_pos = Vector2(enemy_pos.x + length * cos(radians), enemy_pos.y + length * sin(radians))
		positions.append(new_pos)

		var warning = warning_temp.instantiate()
		map.add_child(warning)
		warning.global_position = new_pos
		warnings.append(warning)

	await get_tree().create_timer(GRACE_PERIOD, false).timeout

	for warning in warnings:
		warning.queue_free()

	for i in range(current_pipe_count):
		var pipe = pipe_temp.instantiate()
		pipe.setup(damage)
		map.add_child(pipe)

		pipe.global_position = positions[i]
		pipes.append(pipe)

		AudioSystem.play_sfx(pipe_sfx, pipe.global_position, 0.5)
		await get_tree().create_timer(0.1, false).timeout

	await get_tree().create_timer(0.5, false).timeout

	for pipe in pipes:
		pipe.queue_free()
