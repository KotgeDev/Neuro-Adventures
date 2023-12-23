extends Hitbox
class_name MultiHitbox 

## Number of times the projectile can hit before self-destructing 
@export var count := 1 

func _on_area_entered(area):
	count -= 1
	var modified_damage = apply_damage_multipliers(damage, area)
	area.set_damage(modified_damage)
	if count == 0: 
		self_destruct.emit()
