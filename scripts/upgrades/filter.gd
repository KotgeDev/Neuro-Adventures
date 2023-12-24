extends UpgradeScene

func _ready() -> void: 
	add_to_group("ai_damage_modifiers")

func ai_damage_modifiers(
	BASE_DAMAGE: float, 
	modified_damage: float, 
	area: Area2D
) -> float:
	if area.get_parent() is CollabPartner: 
		match upgrade.lvl: 
			1:
				modified_damage -= BASE_DAMAGE * 0.3 
			2:
				modified_damage -= BASE_DAMAGE * 0.4
			3:
				modified_damage -= BASE_DAMAGE * 0.5
			4:
				modified_damage -= BASE_DAMAGE * 0.7 
				
	return modified_damage
