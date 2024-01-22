extends Collectible

@onready var ai = get_tree().get_first_node_in_group("ai") as AI

func pickup_not_allowed() -> bool:
	if ai.health == ai.MAX_HEALTH:
		return true
	else:
		return false 

func fire_signal() -> void:
	Globals.collect_cookie.emit() 
