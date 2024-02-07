extends UpgradeScene

func _ready() -> void: 
	add_to_group("filter")

func damage_given_modifiers_ai(
	BASE_DAMAGE: float, 
	modified_damage: float, 
	area: Area2D
) -> float:
	if area.get_parent() is CollabPartner: 
		match upgrade.lvl: 
			1:
				modified_damage -= modified_damage * 0.3 
			2:
				modified_damage -= modified_damage * 0.5
			3:
				modified_damage -= modified_damage * 0.75
			4:
				modified_damage -= modified_damage * 0.90
				
	return modified_damage
