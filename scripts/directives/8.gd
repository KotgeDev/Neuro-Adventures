extends Node

func _ready() -> void:
	StatsManager.cr_increase += 0.2

func _exit_tree() -> void:
	StatsManager.cr_increase -= 0.2
