extends Node

var current_dmg_red_inc := 0.0 :
	set(value):
		# Reset
		StatsManager.ai_dmg_red -= current_dmg_red_inc
		# Update
		print("Setting DMG RED to: ", value)
		current_dmg_red_inc = value
		StatsManager.ai_dmg_red += value

func _ready() -> void:
	print("RUNNING INSURGENCY")
	StatsManager.insurgency = true
	StatsManager.filter_changed.connect(_on_filter_changed)
	current_dmg_red_inc = filter_to_dmg_red(StatsManager.filter)

func _on_filter_changed() -> void:
	current_dmg_red_inc = filter_to_dmg_red(StatsManager.filter)

func _exit_tree() -> void:
	StatsManager.insurgency = false
	StatsManager.ai_dmg_red -= current_dmg_red_inc

func filter_to_dmg_red(filter: float) -> float:
	return filter
