extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var map = get_tree().get_first_node_in_group("map") as MAP

func sync_level() -> void:
	match upgrade.lvl:
		1:
			print("Increased atk!")
			ai.ai_distance = 60.0 
			StatsManager.ai_atk_increase += 0.5 
		2:
			ai.ai_distance = 55.0 
			StatsManager.ai_atk_increase += 0.5 
		3:
			ai.ai_distance = 50.0
			StatsManager.ai_atk_increase += 1.0
			map.say_it_back_max = true 
