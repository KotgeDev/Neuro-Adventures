extends Node

func _ready() -> void:
	StatsManager.filter += 0.05

func _exit_tree() -> void:
	StatsManager.filter -= 0.05
