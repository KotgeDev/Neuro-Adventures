extends UpgradeScene

func _ready() -> void:
	print("increasing collab constant")
	StatsManager.collab_atk_const += 0.5
