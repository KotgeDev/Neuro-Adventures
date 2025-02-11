extends UpgradeScene

func _ready() -> void:
	print("increasing collab atk")
	StatsManager.collab_atk_inc += 0.05
