extends Node

var current_evasion_inc := 0.0 :
	set(value):
		# Reset
		StatsManager.collab_evasion -= current_evasion_inc
		# Update
		current_evasion_inc = value
		StatsManager.collab_evasion += value

func _ready() -> void:
	StatsManager.filter_changed.connect(_on_filter_changed)
	current_evasion_inc = filter_to_evasion(StatsManager.filter)

func _on_filter_changed() -> void:
	current_evasion_inc = filter_to_evasion(StatsManager.filter)

func _exit_tree() -> void:
	StatsManager.collab_evasion -= current_evasion_inc

func filter_to_evasion(filter: float) -> float:
	return filter * 0.3
