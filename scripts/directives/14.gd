extends Node

# The latest increase to cooldown
var current_cd_dec := 0.0 :
	set(value):
		# Reset
		StatsManager.cd_reduction -= current_cd_dec
		# Update
		current_cd_dec = value
		StatsManager.cd_reduction += value

func _ready() -> void:
	StatsManager.increase_collection_range.connect(_on_cr_changed)
	current_cd_dec = cr_to_cd(StatsManager.cr_increase)

func _on_cr_changed(value) -> void:
	current_cd_dec = cr_to_cd(StatsManager.cr_increase)

func _exit_tree() -> void:
	StatsManager.collab_atk_mult -= current_cd_dec

func cr_to_cd(cr_inc: float) -> float:
	return cr_inc * 0.3
