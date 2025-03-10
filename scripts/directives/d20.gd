extends Node

func _ready() -> void:
	StatsManager.atk_const += 3.0

func _exit_tree() -> void:
	StatsManager.atk_const -= 3.0
