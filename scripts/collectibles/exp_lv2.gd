extends Collectible

func fire_signal() -> void:
	Globals.collect_exp.emit(2) 

