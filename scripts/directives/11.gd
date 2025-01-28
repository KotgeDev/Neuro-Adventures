extends Node

@onready var ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME) as AI

# The latest multiplier applied to ai_atk_mult
var current_mult := 1.0 :
	set(value):
		# Reset
		StatsManager.ai_atk_mult /= current_mult
		# Update
		current_mult = value
		StatsManager.ai_atk_mult *= value

func _ready() -> void:
	StatsManager.ai_hp_changed.connect(_on_hp_changed)
	current_mult = hp_to_mult(ai.health)

func _on_hp_changed() -> void:
	current_mult = hp_to_mult(ai.health)

func _exit_tree() -> void:
	StatsManager.ai_atk_mult /= current_mult

func hp_to_mult(hp: float) -> float:
	return hp / 20
