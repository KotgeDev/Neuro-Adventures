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
		var total_prc_inc = (
			BASE_DAMAGE * StatsManager.atk_increase +  
			BASE_DAMAGE * StatsManager.ai_atk_increase
		)
		var total_const_inc = (
			StatsManager.atk_const_increase +
			StatsManager.ai_atk_const_increase
		)
		var total_multiplier = (
			StatsManager.atk_mult * 
			StatsManager.ai_atk_mult
		)
		
		final_damage = (BASE_DAMAGE + total_prc_inc) * total_multiplier + total_const_inc
		
		if area.owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER: 
			final_damage -= final_damage * StatsManager.filter 
		
		# For Soul Stealer 
		Globals.ai_attack.emit(final_damage)
	
	elif owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		var total_prc_inc = (
			BASE_DAMAGE * StatsManager.atk_increase +  
			BASE_DAMAGE * StatsManager.collab_atk_increase
		)
		var total_const_inc = (
			StatsManager.atk_const_increase +
			StatsManager.collab_atk_const_increase
		)
		var total_multiplier = (
			StatsManager.atk_mult * 
			StatsManager.collab_atk_mult
		)
		
		final_damage = (BASE_DAMAGE + total_prc_inc) * total_multiplier + total_const_inc
	else: 
		final_damage = BASE_DAMAGE

	return final_damage
