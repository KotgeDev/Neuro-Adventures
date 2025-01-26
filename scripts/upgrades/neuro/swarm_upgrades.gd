extends UpgradeScene

@export var lv1_damage := 2.0
@export var lv2_speed := 60.0
@export var lv3_damage := 3.0
@export var lv4_speed := 80.0

@onready var map = get_tree().get_first_node_in_group("map") as MAP

func _ready() -> void:
	Globals.update_drones.connect(sync_level)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_damage(lv1_damage)
		2:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_damage(lv1_damage)
				drone.max_speed = lv2_speed
		3:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_damage(lv3_damage)
				drone.max_speed = lv2_speed
		4:
			for drone in get_tree().get_nodes_in_group("drone"):
				drone.set_damage(lv3_damage)
				drone.max_speed = lv4_speed
			map.swarm_max = true
