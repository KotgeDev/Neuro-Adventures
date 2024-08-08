extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var map = get_tree().get_first_node_in_group("map") as MAP

var damage_multiplier := 0.5  

func _ready():
	add_to_group(Globals.DAMAGE_GIVEN_MODIFIERS)
	sync_level()

func damage_given_modifiers_global(
	BASE_DAMAGE: float, 
	modified_damage: float,
	area: Area2D
) -> float:
	modified_damage += BASE_DAMAGE * damage_multiplier

	return modified_damage   

func sync_level() -> void:
	match upgrade.lvl:
		1:
			ai.ai_distance = 60.0 
			damage_multiplier = 0.5 
		2:
			ai.ai_distance = 55.0 
			damage_multiplier = 1.0 
		3:
			ai.ai_distance = 50.0
			damage_multiplier = 2.0 
			map.say_it_back_max = true 
