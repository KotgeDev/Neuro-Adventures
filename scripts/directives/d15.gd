extends Node

func _ready() -> void:
	StatsManager.max_hp_inc_pct += 0.16

func _exit_tree() -> void:
	StatsManager.max_hp_inc_pct -= 0.16
