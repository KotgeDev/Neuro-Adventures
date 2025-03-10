extends Node

func _ready() -> void:
	StatsManager.exp_passive = true

func _exit_tree() -> void:
	StatsManager.exp_passive = false
