extends Node

func _ready() -> void:
	StatsManager.atk_inc += 0.1

func _exit_tree() -> void:
	StatsManager.atk_inc -= 0.1
