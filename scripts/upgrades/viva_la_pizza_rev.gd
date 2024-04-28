extends UpgradeScene

@export var lv1_speed := 52.0
@export var lv2_damage := 3.0
@export var lv3_speed := 60.0
@export var lv4_damage := 5.0

@onready var map = get_tree().get_first_node_in_group("map") as MAP

func _ready() -> void:
	sync_level()
	Globals.update_pizza.connect(sync_level)

func sync_level() -> void:
	match upgrade.lvl: 
		1:
			for pizza in get_tree().get_nodes_in_group("pizza"):
				pizza.max_speed = lv1_speed 
		2: 
			for pizza in get_tree().get_nodes_in_group("pizza"):
				pizza.max_speed = lv1_speed 
				pizza.set_damage(lv2_damage)
		3:
			for pizza in get_tree().get_nodes_in_group("pizza"):
				pizza.max_speed = lv3_speed
				pizza.set_damage(lv2_damage)
		4:
			for pizza in get_tree().get_nodes_in_group("pizza"):
				pizza.max_speed = lv3_speed
				pizza.set_damage(lv4_damage)
			map.swarm_max = true 
