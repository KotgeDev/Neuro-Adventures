extends Node

func _ready() -> void:
	StatsManager.atk_const += 1.0

func _exit_tree() -> void:
	StatsManager.atk_const -= 1.0
