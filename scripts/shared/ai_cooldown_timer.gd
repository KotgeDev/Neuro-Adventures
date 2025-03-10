extends Timer
class_name AICooldownTimer
## A Timer for all ai upgrade cooldowns
## wait_time is updated whenever base_cooldown
## or StatsManager.cd_reduction is changed

var base_cooldown: float :
	set(value):
		base_cooldown = value
		cd_reduction_changed()

func _ready() -> void:
	StatsManager.reduce_cooldown.connect(cd_reduction_changed)
	StatsManager.reduce_ai_cooldown.connect(cd_reduction_changed)

func cd_reduction_changed() -> void:
	wait_time = StatsManager.get_final_ai_cd(base_cooldown)
