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

## Use this function to set damage 
func set_damage(damage, area) -> void:
	var modified_damage = _apply_damage_multipliers(damage, area)
	area.set_damage(modified_damage)

func _apply_damage_multipliers(BASE_DAMAGE: float, area: Area2D) -> float:	
	var modified_damage := BASE_DAMAGE 
	
	if owned_by == Globals.Owners.OWNED_BY_AI or owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = _damage_given_modifiers_global(BASE_DAMAGE, modified_damage, area)
	
	if owned_by == Globals.Owners.OWNED_BY_AI:
		modified_damage = _damage_given_modifiers_ai(BASE_DAMAGE, modified_damage, area)
		
	if owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = _damage_given_modifiers_collab(BASE_DAMAGE, modified_damage, area)
	
	return modified_damage

func _damage_given_modifiers_global(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:	
	for upgrade in get_tree().get_nodes_in_group(Globals.DAMAGE_GIVEN_MODIFIERS):
		modified_damage = upgrade.damage_given_modifiers_global(BASE_DAMAGE, modified_damage, area) 

	return modified_damage

func _damage_given_modifiers_ai(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group(Globals.DAMAGE_GIVEN_MODIFIERS_AI):
		modified_damage = upgrade.damage_given_modifiers_ai(BASE_DAMAGE, modified_damage, area) 
	
	var filter = get_tree().get_first_node_in_group("filter")
	if filter:
		modified_damage = filter.damage_given_modifiers_ai(BASE_DAMAGE, modified_damage, area) 
	
	return modified_damage

func _damage_given_modifiers_collab(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group(Globals.DAMAGE_GIVEN_MODIFIERS_COLLAB):
		modified_damage = upgrade.damage_given_modifiers_collab(BASE_DAMAGE, modified_damage, area) 

	return modified_damage
