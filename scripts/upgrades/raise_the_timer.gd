extends UpgradeScene

@onready var map = get_tree().get_first_node_in_group("map") as MAP

func _ready() -> void:
	map.raise_the_timer = true 
	sync_level() 

func sync_level() -> void:
	match upgrade.lvl:
		1:
			Globals.raise_the_timer.emit(1.0, 0.6)
		2:
			Globals.raise_the_timer.emit(1.0, 0.7) 
		3:
			Globals.raise_the_timer.emit(1.0, 0.8)
