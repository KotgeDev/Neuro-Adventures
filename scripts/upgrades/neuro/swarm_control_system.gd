extends UpgradeScene

@onready var map = get_tree().get_first_node_in_group("map") as MAP

func _ready() -> void:
	Globals.update_drones.connect(sync_level)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_stats(50, 2)
		2:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_stats(60, 2)
		3:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_stats(60, 3)
		4:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_stats(80, 3)
			map.swarm_max = true
