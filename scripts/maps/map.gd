extends Node2D
class_name MAP

const AI_POS = Vector2(1217, 322)
const COLLAB_POS = Vector2(1276, 331)
# All map's exact size should be:
# 79 tiles wide including border tiles
# 20 tiles tall including border tiles
# The following are the approx. pixel width & height
# to be used for march duration calculations
const WIDTH = 2470.0
const HEIGHT = 570.0

#region NTX
@export var BASE_NTX_CHANCE := 0.4
@export var NTX_REQ := 50
@export var PITY_REQ := 300
@export var PITY_STEP := 0.1

var enemies_killed_since_last_ntx := 0
var ntx_chance := 0.2
#endregion

#region CHARACTER TEMPLATES
var neuro_template = preload("res://scenes/characters/ais/neuro.tscn")
var evil_template = preload("res://scenes/characters/ais/evil.tscn")
var vedal_template = preload("res://scenes/characters/collab_partners/vedal.tscn")
var anny_template = preload("res://scenes/characters/collab_partners/anny.tscn")
#endregion

#region ACHIEVEMENT CONDITIONS
var gymbag_drone_count := 0
var swarm_max := false
var raise_the_timer := false
var say_it_back_max := false
var dual_strike_max := false
#endregion

#region OTHER
var collectible_generators = []
var ai_scene
var collab_scene
var enemy_stat_mult = 1.0
#endregion

#region ENDLESS MODE
var score = 0
func endless_stat_scale(i: int) -> void:
	if i == 0:
		enemy_stat_mult = 1.0
	else:
		enemy_stat_mult = i * 1.5
#endregion

# 1, 1.5,

#region MONITOR
var monitor_template = preload("res://scenes/interactive_objects/monitor.tscn")
#endregion

#region MARCHES
var horizontal_march = preload("res://scenes/enemies/marches/horizontal_march.tscn")
var vertical_march = preload("res://scenes/enemies/marches/vertical_march.tscn")
#endregion

func _ready() -> void:
	Globals.add_collectible_generator.connect(_on_add_collectible_generator)
	Globals.enemy_killed.connect(_on_enemy_killed)

	match SettingsManager.settings.ai_selected:
		Globals.CharacterChoice.NEURO:
			ai_scene = neuro_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = AI_POS
		Globals.CharacterChoice.EVIL:
			ai_scene = evil_template.instantiate()
			add_child(ai_scene)
			ai_scene.global_position = AI_POS

	match SettingsManager.settings.collab_partner_selected:
		Globals.CharacterChoice.VEDAL:
			collab_scene = vedal_template.instantiate()
			add_child(collab_scene)
			collab_scene.global_position = COLLAB_POS
		Globals.CharacterChoice.ANNY:
			collab_scene = anny_template.instantiate()
			add_child(collab_scene)
			collab_scene.global_position = COLLAB_POS

	StatsManager.reset()

	add_to_group(Globals.MAP_GROUP_NAME)
	Globals.map_ready.emit()

	if MapManager.map_mode == MapManager.MapMode.ENDLESS:
		spawn_enemies_endless()
	elif MapManager.map_mode == MapManager.MapMode.HARD:
		enemy_stat_mult = 2.0
		spawn_enemies()
	elif MapManager.map_mode == MapManager.MapMode.NORMAL:
		enemy_stat_mult = 1.0
		spawn_enemies()

func spawn_monitor() -> void:
	var monitor = monitor_template.instantiate()
	monitor.global_position = get_random_pos()
	add_child(monitor)

func get_random_pos() -> Vector2:
	var angle
	var pos
	var collab = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)
	var navi_agent: NavigationAgent2D = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME).navigation_agent
	var collab_pos = collab.global_position

	#TODO: Find a more effeceint way to do this that is not just
	# randomly generating coordinates until its something valid.
	while true:
		# Find a random position
		angle = randf() * PI * 2
		var offset = Vector2(cos(angle), sin(angle)) * 150
		pos = offset + collab_pos

		# Check if position is valid
		var nav_pos = NavigationServer2D.map_get_closest_point(navi_agent.get_navigation_map(), pos)
		if pos.distance_to(nav_pos) < 0.01:
			break
		else:
			pass
	return pos

func _on_add_collectible_generator(generator: CollectibleGenerator) -> void:
	collectible_generators.append(generator)

func _on_enemy_killed(value: int) -> void:
	score += value

func add_march(march_template: PackedScene, enemy_template: PackedScene, interval := 1000.0, count := 1) -> void:
	var length
	if march_template == horizontal_march:
		length = WIDTH
	else:
		length = HEIGHT
	var sample_enemy = enemy_template.instantiate() as SimpleEnemy
	var march_duration = (length / 2.0) / sample_enemy.BASE_MAX_SPEED
	var march = march_template.instantiate()
	march.setup(enemy_template, march_duration, interval, count)
	add_child(march)

## Override function to use
func spawn_enemies() -> void:
	pass

## Override function to use
func spawn_enemies_endless() -> void:
	pass
