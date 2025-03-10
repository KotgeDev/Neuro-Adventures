extends UpgradeScene

const GRACE_PERIOD := 1.5
const MAX_PIPE_RANGE := 100
const MAX_DIST_FROM_EVIL := 300

@onready var enemy_search_area = $EnemySearchArea
@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME)
@onready var timer: AICooldownTimer = $AICooldownTimer
@onready var ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)

var pipe_temp: PackedScene = preload("res://scenes/projectiles/pipe.tscn")
var warning_temp: PackedScene = preload("res://scenes/projectiles/pipe_warning.tscn")
var pipe_sfx: AudioStream = preload("res://assets/sfx/metalpipe5.wav")

var damage: float
var count: int
var pipe_count := 10

func get_data() -> String:
	var data = (
		get_atk_str(damage) + "\n" +
		get_cd_str(timer.base_cooldown) + "\n" +
		get_general_str("Pipes", count*pipe_count)
	)
	return data

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
			set_stats(5, 1, 8, 5)
		2:
			set_stats(0, 0, 12, 0)
		3:
			set_stats(0, 2, 0, 0)
		4:
			set_stats(10, 0, 0, 0)
		5:
			set_stats(0, 0, 0, 4)
		6:
			set_stats(0, 4, 0, 0)

func _on_ai_cooldown_timer_timeout():
	var enemies := []

	for enemy in enemy_search_area.get_overlapping_areas():
		enemies.append(enemy)
	enemies.shuffle()

	for i in range(count):
		if enemies.size() > i:
			drop_pipes(enemies[i].global_position)

func get_random_positions(size: int) -> Array:
	var results = []

	for i in range(size):
		var pos
		var valid_pos_found := false
		var navi_agent: NavigationAgent2D = ai.navigation_agent
		var ai_pos = ai.global_position

		while not valid_pos_found:
			# Find a random position
			var radians = randf_range(0, TAU)
			var length = randi_range(0, MAX_DIST_FROM_EVIL)
			var offset = Vector2(length * cos(radians), length * sin(radians))
			pos = offset + ai_pos

			# Check if position is valid
			var nav_pos = NavigationServer2D.map_get_closest_point(navi_agent.get_navigation_map(), pos)
			if pos.distance_to(nav_pos) < 0.01 and check_near_pos(pos, results):
				valid_pos_found = true
				results.append(pos)

	return results

func check_near_pos(pos: Vector2, positions: Array) -> bool:
	for prev_pos in positions:
		if pos.distance_to(prev_pos) < MAX_PIPE_RANGE:
			return false
	return true

func drop_pipes(pos: Vector2) -> void:
	var current_pipe_count = pipe_count

	var positions = []
	var warnings = []
	var pipes = []
	var angle_interval = TAU / current_pipe_count
	var max_angle_dev = angle_interval - angle_interval * 0.5

	for i in range(current_pipe_count):
		var radians = angle_interval * i + randf_range(0, max_angle_dev)
		var length = randi_range(10, MAX_PIPE_RANGE)
		var offset = Vector2(length * cos(radians), length * sin(radians))
		var new_pos = pos + offset
		positions.append(new_pos)

	positions.shuffle()
	for po in positions:
		var warning = warning_temp.instantiate()
		map.add_child(warning)
		warning.global_position = po
		warnings.append(warning)

	await get_tree().create_timer(GRACE_PERIOD, false).timeout

	for warning in warnings:
		warning.queue_free()

	AudioSystem.play_sfx(pipe_sfx, pos, 0.7)

	for po in positions:
		var pipe = pipe_temp.instantiate()
		pipe.setup(damage)
		map.add_child(pipe)

		pipe.global_position = po
		pipes.append(pipe)

	await get_tree().create_timer(1.0, false).timeout

	for pipe in pipes:
		pipe.queue_free()
