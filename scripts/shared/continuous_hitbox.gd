extends Hitbox
class_name ContinuousHitbox 

@onready var hit_timer = $HitTimer

func _on_hit_timer_timeout():
	for area in get_overlapping_areas():
		var modified_damage = apply_damage_multipliers(damage, area)
		area.set_damage(modified_damage)

func _on_duration_timeout():
	self_destruct.emit()

func _on_area_entered(area):
	hit_timer.start()
	_on_hit_timer_timeout() 
	
