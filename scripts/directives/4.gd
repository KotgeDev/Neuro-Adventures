extends Node

func _ready() -> void:
	StatsManager.speed_increase += 0.1

func _exit_tree() -> void:
	StatsManager.speed_increase -= 0.1
