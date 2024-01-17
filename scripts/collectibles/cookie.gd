extends Collectible

func fire_signal() -> void:
	Globals.collect_cookie.emit() 
