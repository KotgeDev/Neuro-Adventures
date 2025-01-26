extends Hitbox
class_name MultiHitbox

## Number of times the projectile can hit before self-destructing
@export var count := 1

func _on_area_entered(area):
	count -= 1
	give_damage(damage, area)
	if count == 0:
		self_destruct.emit()
