extends UpgradeScene

@onready var ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			ai.ai_distance = 80.0 
			StatsManager.ai_atk_increase += 0.5 
		2:
			ai.ai_distance = 90.0 
			StatsManager.ai_atk_increase += 0.5 
		3:
			ai.ai_distance = 100.0
			StatsManager.ai_atk_increase += 1.0
