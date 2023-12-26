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
		modified_damage = global_damage_modifiers(BASE_DAMAGE, modified_damage, area)
	
	if owned_by == Globals.Owners.OWNED_BY_AI:
		modified_damage = ai_damage_modifiers(BASE_DAMAGE, modified_damage, area)
		
	if owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = collab_partner_damage_modifiers(BASE_DAMAGE, modified_damage, area)
	
	return modified_damage

func global_damage_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:	
	for upgrade in get_tree().get_nodes_in_group("global_damage_modifiers"):
		modified_damage = upgrade.global_damage_modifiers(BASE_DAMAGE, modified_damage, area) 

	return modified_damage

func ai_damage_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group("ai_damage_modifiers"):
		modified_damage = upgrade.ai_damage_modifiers(BASE_DAMAGE, modified_damage, area) 

	return modified_damage

func collab_partner_damage_modifiers(BASE_DAMAGE: float, modified_damage: float, area: Area2D) -> float:
	for upgrade in get_tree().get_nodes_in_group("collab_partner_damage_modifiers"):
		modified_damage = upgrade.collab_partner_damage_modifiers(BASE_DAMAGE, modified_damage, area) 

	return modified_damage

