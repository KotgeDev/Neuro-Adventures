extends UpgradeScene

func sync_level() -> void:
	match upgrade.lvl:
		1:
			StatsManager.filter += 0.25
		2:
			StatsManager.filter += 0.25
		3:
			StatsManager.filter += 0.2
		4:
			StatsManager.filter += 0.1
