extends UpgradeScene

@export var DAMAGE := 8.0 
@export var GRACE_PERIOD := 1.5 
@export var LV1_FREQUENCY := 6.0 
@export var LV2_FREQUENCY := 4.5 
@export var LV4_FREQUENCY := 2.5 

@onready var launch_timer = $LaunchTimer
@onready var enemy_search_area = $EnemySearchArea
@onready var map = get_tree().get_first_node_in_group("map")

var nuke_projectile: PackedScene = preload("res://scenes/projectiles/inuke6000_explosion.tscn")
var damage: float 
var grace_period: float
var enemy_count: int 

func sync_level() -> void:
	match upgrade.lvl:
		1:
			damage = DAMAGE
			grace_period = GRACE_PERIOD
			launch_timer.wait_time = LV1_FREQUENCY
			enemy_count = 1
			
		2:
			launch_timer.wait_time = LV2_FREQUENCY
		3:
			enemy_count = 2
		4:
			launch_timer.wait_time = LV4_FREQUENCY
		5:
			enemy_count = 3

func _on_launch_timer_timeout():
	var enemies := []

	for enemy in enemy_search_area.get_overlapping_areas():
		enemies.append(enemy)
	enemies.shuffle()
	
	for i in range(enemy_count):
		if enemies.size() >= i + 1: 
			launch_nuke(enemies[i])

func launch_nuke(enemy) -> void: 
	var nuke = nuke_projectile.instantiate()
	nuke.setup(damage, grace_period)
	nuke.global_position = enemy.global_position	
	map.add_child(nuke) 
