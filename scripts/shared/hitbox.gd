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

## Apply this function to damage before setting any damage
## Make sure to use a temporary variable for storign the return value
## so that the original damage variable is unchanged. 
func apply_damage_multipliers(BASE_DAMAGE: float, area: Area2D) -> float:	
	var modified_damage := BASE_DAMAGE 
	
	if owned_by == Globals.Owners.OWNED_BY_AI or owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = damage_given_modifiers_global(BASE_DAMAGE, modified_damage, area)
	
	if owned_by == Globals.Owners.OWNED_BY_AI:
		modified_damage = damage_given_modifiers_ai(BASE_DAMAGE, modified_damage, area)
		
	if owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = damage_given_modifiers_collab(BASE_DAMAGE, modified_damage, area)
	
	return modified_damage

func damage_given_modifiers_global(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:	
	for upgrade in get_tree().get_nodes_in_group("damage_given_modifiers_global"):
		modified_damage = upgrade.damage_given_modifiers_global(BASE_DAMAGE, modified_damage, area) 

	return modified_damage

func damage_given_modifiers_ai(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group("damage_given_modifiers_ai"):
		modified_damage = upgrade.damage_given_modifiers_ai(BASE_DAMAGE, modified_damage, area) 
	
	var filter = get_tree().get_first_node_in_group("filter")
	if filter:
		modified_damage = filter.damage_given_modifiers_ai(BASE_DAMAGE, modified_damage, area) 
	
	return modified_damage

func damage_given_modifiers_collab(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group("damage_given_modifiers_collab"):
		modified_damage = upgrade.damage_given_modifiers_collab(BASE_DAMAGE, modified_damage, area) 

	return modified_damage

