extends Timer
class_name CollabCooldownTimer
## A Timer for all collab upgrade cooldowns
## wait_time is updated whenever base_cooldown
## or StatsManager.cd_reduction is changed

var base_cooldown: float :
	set(value):
		base_cooldown = value
		cd_reduction_changed()

func _ready() -> void:
	StatsManager.reduce_cooldown.connect(cd_reduction_changed)
	StatsManager.reduce_collab_cooldown.connect(cd_reduction_changed)

func cd_reduction_changed() -> void:
	wait_time = StatsManager.get_final_collab_cd(base_cooldown)
