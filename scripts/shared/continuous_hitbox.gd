extends Hitbox
class_name ContinuousHitbox 

@onready var hit_timer = $HitTimer

var areas_count := 0 

func _on_hit_timer_timeout():
	for area in get_overlapping_areas():
		var modified_damage = apply_damage_multipliers(damage, area)
		area.set_damage(modified_damage)

func _on_duration_timeout():
	self_destruct.emit()

func _on_area_entered(area):
	areas_count += 1 
	if areas_count == 1:
		hit_timer.start()
		_on_hit_timer_timeout() 
	
func _on_area_exited(area):
	areas_count -= 1
	if areas_count == 0:
		hit_timer.stop()
