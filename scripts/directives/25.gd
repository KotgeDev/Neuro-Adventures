extends Node

func _ready() -> void:
	StatsManager.exp_mult += 1

func _exit_tree() -> void:
	StatsManager.exp_mult -= 1
