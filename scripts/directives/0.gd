extends Node

func _ready() -> void:
	StatsManager.cd_reduction += 0.1

func _exit_tree() -> void:
	StatsManager.cd_reduction -= 0.1
