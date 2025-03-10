extends Node

func _ready() -> void:
	StatsManager.drone_spd_inc += 0.5

func _exit_tree() -> void:
	StatsManager.drone_spd_inc -= 0.5
