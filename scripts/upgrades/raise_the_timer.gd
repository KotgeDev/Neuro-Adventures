extends UpgradeScene

func _ready() -> void:
	sync_level() 

func sync_level() -> void:
	match upgrade.lvl:
		1:
			Globals.raise_the_timer.emit(1.0, 0.6)
		2:
			Globals.raise_the_timer.emit(1.0, 0.7) 
		3:
			Globals.raise_the_timer.emit(1.0, 0.8)
