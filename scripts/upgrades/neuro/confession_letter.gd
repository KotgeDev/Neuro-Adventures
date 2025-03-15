extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group("ai") as AI
@onready var map = get_tree().get_first_node_in_group("map") as MAP

func sync_level() -> void:
	match upgrade.lvl:
		1:
			ai.ai_distance -= 2.5
			StatsManager.ai_atk_inc += 0.05
		2:
			ai.ai_distance -= 2.5
			StatsManager.ai_atk_inc += 0.05
		3:
			ai.ai_distance -= 2.5
			StatsManager.ai_atk_inc += 0.05
		4:
			ai.ai_distance -= 2.5
			StatsManager.ai_atk_inc += 0.05
		5:
			ai.ai_distance -= 5.0
			StatsManager.ai_atk_inc += 0.1

			map.say_it_back_max = true
