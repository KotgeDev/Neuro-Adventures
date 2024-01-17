extends Collectible

func fire_signal() -> void:
	Globals.collect_creggs.emit() 
