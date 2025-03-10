extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			ai.ai_distance += 5.0
			StatsManager.ai_atk_inc += 0.1
		2:
			ai.ai_distance += 5.0
			StatsManager.ai_atk_inc += 0.1
		3:
			ai.ai_distance += 5.0
			StatsManager.ai_atk_inc += 0.1
