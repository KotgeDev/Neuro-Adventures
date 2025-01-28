extends Node

func _ready() -> void:
	StatsManager.ai_life +=1

func _exit_tree() -> void:
	StatsManager.ai_life -=1
	if StatsManager.ai_life <= 0:
		Globals.game_over.emit()
