extends Node

func _ready() -> void:
	StatsManager.drone_automation = true

func _exit_tree() -> void:
	StatsManager.drone_automation = false
