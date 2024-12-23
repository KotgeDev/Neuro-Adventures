extends Timer
class_name CooldownTimer
## A Timer for all upgrade cooldowns 
## wait_time is updated whenever base_cooldown
## or StatsManager.cd_reduction is changed  

var base_cooldown: float : 
	set(value):
		base_cooldown = value  
		wait_time = base_cooldown - base_cooldown * StatsManager.cd_reduction

func _ready() -> void:
	StatsManager.reduce_cooldown.connect(_on_cd_reduction_changed)

func _on_cd_reduction_changed(reduction) -> void:
	wait_time = base_cooldown - base_cooldown * StatsManager.cd_reduction	
