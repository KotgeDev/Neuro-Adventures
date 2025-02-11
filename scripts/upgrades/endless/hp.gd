extends UpgradeScene

func _ready() -> void:
	print("Increasing hp")
	StatsManager.max_hp_inc_pct += 0.02
