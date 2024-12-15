extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group("ai")

var damage_multiplier := 0.5  

func _ready():
	add_to_group(Globals.GLOBAL_ATTACK_MODIFIERS)

func global_attack_modifiers(
	BASE_DAMAGE: float, 
	modified_damage: float,
	area: Area2D
) -> float:
	modified_damage += BASE_DAMAGE * damage_multiplier

	return modified_damage   

func sync_level() -> void:
	match upgrade.lvl:
		1:
			ai.ai_distance = 80.0 
			damage_multiplier = 0.5 
		2:
			ai.ai_distance = 90.0 
			damage_multiplier = 1.0 
		3:
			ai.ai_distance = 100.0
			damage_multiplier = 2.0 
