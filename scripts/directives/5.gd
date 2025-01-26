extends Node

func _ready() -> void:
	StatsManager.switch_time_dec_pct += 0.75

func _exit_tree() -> void:
	StatsManager.switch_time_dec_pct -= 0.75
