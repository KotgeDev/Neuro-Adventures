## Parent class for all hitboxes
## When using, make sure to set the following properties:
## owned_by
## damage
## collision layer
## CollisionPolygon2D
## count (Only for MultiHitboxes)
extends Area2D
class_name Hitbox

signal self_destruct

@export var owned_by: Globals.Owners
@export var damage: float

## Use this function to give x damage to area
func give_damage(damage, area: Hurtbox) -> void:
	var final_damage = _calculate_final_damage(damage, area)
	area.receive_damage(final_damage)

func _calculate_final_damage(BASE_DAMAGE: float, area: Hurtbox) -> float:
	var final_damage

	if owned_by == Globals.Owners.OWNED_BY_AI:
		if get_parent() is Drone:
			final_damage = StatsManager.get_final_drone_atk(BASE_DAMAGE)
		else:
			final_damage = StatsManager.get_final_ai_atk(BASE_DAMAGE)

		if area.owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER and not StatsManager.insurgency:
			final_damage -= final_damage * min(1, StatsManager.filter)

		Globals.ai_attack.emit(final_damage)  # Used by Soul Stealer
	elif owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		final_damage = StatsManager.get_final_collab_atk(BASE_DAMAGE)
	else:
		final_damage = BASE_DAMAGE

	return final_damage
