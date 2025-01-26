extends CollabPartner

const CREGGS_HEALTH := 7.0

func extended_signals() -> void:
	Globals.collect_creggs.connect(_on_collect_creggs)

func _on_collect_creggs() -> void:
	health += CREGGS_HEALTH

	if health >= max_health:
		health = max_health

	Globals.update_collab_partner_health.emit(max_health, health, false)
