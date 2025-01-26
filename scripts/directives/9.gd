extends Node

@onready var ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME) as AI
@onready var collab = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME) as CollabPartner

var current_ai_inc := 0.0
var current_collab_inc := 0.0

func _ready() -> void:
	StatsManager.ai_max_speed_changed.connect(_on_ai_speed_changed)
	StatsManager.collab_max_speed_changed.connect(_on_collab_speed_changed)
	# AI
	current_ai_inc = speed_to_evasion(ai.max_speed)
	StatsManager.ai_evasion += current_ai_inc
	# Collab Partner
	current_collab_inc = speed_to_evasion(collab.max_speed)
	StatsManager.collab_evasion += current_collab_inc

func _on_ai_speed_changed() -> void:
	# Remove the outdated increase
	StatsManager.ai_evasion -= current_ai_inc
	# Update current increase
	current_ai_inc = speed_to_evasion(ai.max_speed)
	StatsManager.ai_evasion += current_ai_inc

func _on_collab_speed_changed() -> void:
	# Remove the outdated increase
	StatsManager.collab_evasion -= current_collab_inc
	# Update current increase
	current_collab_inc = speed_to_evasion(ai.max_speed)
	StatsManager.collab_evasion += current_collab_inc

func speed_to_evasion(max_speed: float) -> float:
	return max_speed / 2.0

func _exit_tree() -> void:
	StatsManager.ai_evasion -= current_ai_inc
	StatsManager.collab_evasion -= current_collab_inc
