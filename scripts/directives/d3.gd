extends Node

func _ready() -> void:
	StatsManager.evasion += 0.05

func _exit_tree() -> void:
	StatsManager.evasion -= 0.05
