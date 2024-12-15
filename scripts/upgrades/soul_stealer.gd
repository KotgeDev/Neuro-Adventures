extends UpgradeScene

var percentage = 1

func _ready():
	add_to_group(Globals.AI_ATTACK_MODIFIERS)

func ai_attack_modifiers(
	BASE_DAMAGE: float, 
	modified_damage: float,
	area: Area2D
) -> float:
	Globals.heal_ai.emit(modified_damage * percentage)
	
	return modified_damage  

func sync_level() -> void:
	match upgrade.lvl:
		1:
			percentage = 0.01
		2:
			percentage = 0.02
		3:
			percentage = 0.03
		4: 
			percentage = 0.05
