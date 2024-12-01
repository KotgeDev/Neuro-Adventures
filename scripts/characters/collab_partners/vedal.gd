extends CollabPartner

const CREGGS_HEALTH := 7.0

func extended_signals() -> void:
	Globals.collect_creggs.connect(_on_collect_creggs)

func _on_collect_creggs() -> void:
	health += CREGGS_HEALTH
	
	if health >= MAX_HEALTH:
		health = MAX_HEALTH
	
	Globals.update_collab_partner_health.emit(MAX_HEALTH, health, false)
