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
	var modified_damage = _apply_attack_modifiers(damage, area)
	area.receive_damage(modified_damage)

func _apply_attack_modifiers(BASE_DAMAGE: float, area: Area2D) -> float:	
	var modified_damage := BASE_DAMAGE 
	
	if owned_by == Globals.Owners.OWNED_BY_AI or owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = _global_attack_modifiers(BASE_DAMAGE, modified_damage, area)
	
	if owned_by == Globals.Owners.OWNED_BY_AI:
		modified_damage = _ai_attack_modifiers(BASE_DAMAGE, modified_damage, area)
		
	if owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = _collab_attack_modifiers(BASE_DAMAGE, modified_damage, area)
	
	return modified_damage

func _global_attack_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:	
	for upgrade in get_tree().get_nodes_in_group(Globals.GLOBAL_ATTACK_MODIFIERS):
		modified_damage = upgrade.global_attack_modifiers(BASE_DAMAGE, modified_damage, area) 
		if modified_damage == 0:
			return 0 
		
	return modified_damage

func _ai_attack_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group(Globals.AI_ATTACK_MODIFIERS):
		modified_damage = upgrade.ai_attack_modifiers(BASE_DAMAGE, modified_damage, area)
		if modified_damage == 0: 
			return 0  
	
	return modified_damage

func _collab_attack_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group(Globals.COLLAB_ATTACK_MODIFIERS):
		modified_damage = upgrade.collab_attack_modifiers(BASE_DAMAGE, modified_damage, area) 
		if modified_damage == 0:
			return 0
		
	return modified_damage
