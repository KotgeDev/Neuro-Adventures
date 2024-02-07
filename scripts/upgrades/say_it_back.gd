extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group("ai")

func _ready():
	add_to_group("damage_given_modifiers_global")
	sync_level()

func damage_given_modifiers_global(
	BASE_DAMAGE: float, 
	modified_damage: float,
	area: Area2D
) -> float:
	match upgrade.lvl: 
		1:
			modified_damage += BASE_DAMAGE * 0.5
		2:
			modified_damage += BASE_DAMAGE * 1.0
		3:
			modified_damage += BASE_DAMAGE * 2.0

	return modified_damage   

func sync_level() -> void:
	match upgrade.lvl:
		1:
			ai.ai_distance = 60.0 
		2:
			ai.ai_distance = 55.0 
		3:
			ai.ai_distance = 50.0
