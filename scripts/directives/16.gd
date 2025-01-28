extends Node

func _ready() -> void:
	StatsManager.collab_atk_const += 1.0

func _exit_tree() -> void:
	StatsManager.collab_atk_const -= 0.1
