extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group("ai")

func _ready():
	add_to_group("global_damage_modifiers")
	sync_level()

func global_damage_modifiers(
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
			ai.ai_distance = 45.0 
		2:
			ai.ai_distance = 35.0 
		3:
			ai.ai_distance = 20.0
