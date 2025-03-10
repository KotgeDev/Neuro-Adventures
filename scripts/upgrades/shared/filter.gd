extends UpgradeScene

func sync_level() -> void:
	match upgrade.lvl:
		1:
			StatsManager.filter += 0.15
		2:
			StatsManager.filter += 0.15
		3:
			StatsManager.filter += 0.15
		4:
			StatsManager.filter += 0.15
		5:
			StatsManager.filter += 0.15
		6:
			StatsManager.filter += 0.15
