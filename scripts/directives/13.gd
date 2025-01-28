extends Node

# The latest cooldown reduction applied to ai cooldown
var current_ai_cd_red := 0.0 :
	set(value):
		# Remove previous increase
		StatsManager.ai_cd_reduction -= current_ai_cd_red
		# Update to newer value
		current_ai_cd_red = value
		StatsManager.ai_cd_reduction += value
# The latest cooldown reduction applied to collab cooldown
var current_collab_cd_red := 0.0 :
	set(value):
		# Remove previous increase
		StatsManager.collab_cd_reduction -= current_collab_cd_red
		# Update to newer value
		current_collab_cd_red = value
		StatsManager.collab_cd_reduction += value

func _ready() -> void:
	# AI
	StatsManager.evasion_changed.connect(_on_ai_evasion_changed)
	StatsManager.ai_evasion_changed.connect(_on_ai_evasion_changed)
	current_ai_cd_red = evasion_to_cd(StatsManager.evasion + StatsManager.ai_evasion)
	# Collab
	StatsManager.evasion_changed.connect(_on_collab_evasion_changed)
	StatsManager.ai_evasion_changed.connect(_on_collab_evasion_changed)
	current_collab_cd_red = evasion_to_cd(StatsManager.evasion + StatsManager.collab_evasion)

func _on_ai_evasion_changed() -> void:
	current_ai_cd_red = evasion_to_cd(StatsManager.evasion + StatsManager.ai_evasion)

func _on_collab_evasion_changed() -> void:
	current_collab_cd_red = evasion_to_cd(StatsManager.evasion + StatsManager.collab_evasion)

func _exit_tree() -> void:
	StatsManager.ai_cd_reduction -= current_ai_cd_red
	StatsManager.collab_cd_reduction -= current_collab_cd_red

func evasion_to_cd(evasion: float) -> float:
	return evasion * 0.5
