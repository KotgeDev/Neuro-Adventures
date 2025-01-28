extends UpgradeScene

const GRACE_PERIOD := 1.5

@onready var launch_timer = $LaunchTimer
@onready var enemy_search_area = $EnemySearchArea
@onready var map = get_tree().get_first_node_in_group("map")

var nuke_projectile: PackedScene = preload("res://scenes/projectiles/inuke6000_explosion.tscn")

var damage: float
var count: int

func set_stats(_damage: float, wait_time: float, _count: int) -> void:
	if _damage: damage = _damage
	if wait_time: launch_timer.base_cooldown = wait_time
	if _count: count = _count

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_stats(16.0, 6.0, 1)
		2:
			set_stats(0, 4.5, 0)
		3:
			set_stats(0, 0, 2)
		4:
			set_stats(0, 2.5, 0)
		5:
			set_stats(0, 0, 4)
		6:
			set_stats(0, 0, 8)

func _on_launch_timer_timeout():
	var enemies := []

	for enemy in enemy_search_area.get_overlapping_areas():
		enemies.append(enemy)
	enemies.shuffle()

	for i in range(count):
		if enemies.size() >= i + 1:
			launch_nuke(enemies[i])

func launch_nuke(enemy) -> void:
	var nuke = nuke_projectile.instantiate()
	nuke.setup(damage, GRACE_PERIOD)
	nuke.global_position = enemy.global_position
	map.add_child(nuke)
