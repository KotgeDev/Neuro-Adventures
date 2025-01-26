extends UpgradeScene

func sync_level() -> void:
	match upgrade.lvl: 
		1: 
			StatsManager.filter = 0.3 
		2: 
			StatsManager.filter = 0.4 
		3:
			StatsManager.filter = 0.5 
		4:
			StatsManager.filter = 0.7
