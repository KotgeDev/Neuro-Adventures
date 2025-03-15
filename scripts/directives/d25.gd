extends Node

func _ready() -> void:
	StatsManager.harmony = true
	StatsManager.speed_increase += 0.1
	StatsManager.chase_radius_dec += 0.5

func _exit_tree() -> void:
	StatsManager.harmony = false
	StatsManager.speed_increase -= 0.1
	StatsManager.chase_radius_dec -= 0.5
