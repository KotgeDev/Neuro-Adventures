extends UpgradeScene

func _ready() -> void:
	print("increasing ai atk")
	StatsManager.ai_atk_inc += 0.02
