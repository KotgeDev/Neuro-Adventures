extends Node2D

const RADIUS = 300
const SAFE_DISTANCE = 25.0
@onready var HALF_WIDTH = get_viewport().size.x
@onready var HALF_HEIGHT = get_viewport().size.y

func _ready() -> void:
	Globals.spawn.connect(_on_spawn)

func _on_spawn(scene_template, count: int, time_interval: float, last_batch := false) -> void:
	for i in range(count):
		await get_tree().create_timer(time_interval, false).timeout
		var enemy = scene_template.instantiate()
		enemy.global_position = get_random_pos()
		add_child(enemy)

		if last_batch and i == count - 1:
			enemy.last_enemy = true

func get_random_pos() -> Vector2:
	var angle
	var pos
	var ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)
	var collab = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)
	var navi_agent: NavigationAgent2D = ai.navigation_agent
	var ai_pos = ai.global_position
	var collab_pos = collab.global_position

	#TODO: Find a more effeceint way to do this that is not just
	# randomly generating coordinates until its something valid.
	while true:
		# Find a random position
		angle = randf() * PI * 2
		var offset = Vector2(cos(angle), sin(angle)) * RADIUS
		pos = offset + ai_pos

		# Check if position is valid
		var nav_pos = NavigationServer2D.map_get_closest_point(navi_agent.get_navigation_map(), pos)
		if pos.distance_to(collab_pos) > SAFE_DISTANCE and \
			pos.distance_to(nav_pos) < 0.01:
			break
		else:
			pass
	return pos
