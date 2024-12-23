extends Collectible

func pickup_not_allowed() -> bool:
	if collab_partner.health == collab_partner.max_health:
		return true
	else:
		return false 

func fire_signal() -> void:
	Globals.collect_orange.emit() 
