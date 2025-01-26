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
		var total_atk_inc = (
			StatsManager.atk_inc +
			StatsManager.ai_atk_inc
		)
		if get_parent() is Drone:
			total_atk_inc += StatsManager.drone_atk_inc

		var total_const = (
			StatsManager.atk_const +
			StatsManager.ai_atk_const
		)
		var total_multiplier = (
			StatsManager.atk_mult *
			StatsManager.ai_atk_mult
		)

		final_damage = BASE_DAMAGE * (1.0 + total_atk_inc) * total_multiplier + total_const

		if area.owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
			final_damage -= final_damage * StatsManager.filter

		# For Soul Stealer
		Globals.ai_attack.emit(final_damage)

	elif owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		var total_atk_inc = (
			StatsManager.atk_inc +
			StatsManager.collab_atk_inc
		)
		var total_const = (
			StatsManager.atk_const +
			StatsManager.collab_atk_const
		)
		var total_multiplier = (
			StatsManager.atk_mult *
			StatsManager.collab_atk_mult
		)

		final_damage = BASE_DAMAGE * (1.0 + total_atk_inc) * total_multiplier + total_const
	else:
		final_damage = BASE_DAMAGE

	return final_damage
