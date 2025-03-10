extends Node

func _ready() -> void:
	StatsManager.drone_atk_inc += 1.0

func _exit_tree() -> void:
	StatsManager.drone_atk_inc -= 1.0
