extends CollabPartner

const HEAL_INCREASE := 0.4

var healing_factor := 0.1

func extended_signals() -> void:
	Globals.collect_orange.connect(_on_collect_orange)

func _on_collect_orange() -> void:
	healing_factor += HEAL_INCREASE
	await get_tree().create_timer(30.0, false).timeout
	healing_factor -= HEAL_INCREASE

func _on_heal_timer_timeout():
	health += healing_factor

	if health >= max_health:
		health = max_health

	Globals.update_collab_partner_health.emit(max_health, health, false)
