extends Node

# The latest multiplier applied to collab_atk_mult
var current_mult := 1.0 :
	set(value):
		# Reset
		StatsManager.collab_atk_mult /= current_mult
		# Update
		current_mult = value
		StatsManager.collab_atk_mult *= value

func _ready() -> void:
	StatsManager.increase_collection_range.connect(_on_cr_changed)
	current_mult = cr_to_mult(StatsManager.cr_increase)

func _on_cr_changed() -> void:
	current_mult = cr_to_mult(StatsManager.cr_increase)

func _exit_tree() -> void:
	StatsManager.collab_atk_mult /= current_mult

func cr_to_mult(cr_inc: float) -> float:
	return 1.0 + cr_inc
