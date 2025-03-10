extends Node

func _ready() -> void:
	StatsManager.ai_dmg_red += 0.1

func _exit_tree() -> void:
	StatsManager.ai_dmg_red -= 0.1
