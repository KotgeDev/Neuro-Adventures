extends UpgradeScene

func _ready() -> void:
	print("increasing ai constant")
	StatsManager.ai_atk_const += 0.2
