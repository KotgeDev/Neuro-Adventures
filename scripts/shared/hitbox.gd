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
	var ai = get_tree().get_first_node_in_group("ai") as AI 
	var collab_partner = get_tree().get_first_node_in_group("collab_partner") as CollabPartner
	var modified_damage := BASE_DAMAGE 
	
	if owned_by == Globals.Owners.OWNED_BY_AI or owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = collab_partner.apply_global_damage_modifiers(BASE_DAMAGE, modified_damage)
		modified_damage = ai.apply_global_damage_modifiers(BASE_DAMAGE, modified_damage)
	
	if owned_by == Globals.Owners.OWNED_BY_AI:
		modified_damage = ai.apply_ai_damage_modifiers(BASE_DAMAGE, modified_damage, area)
	
	if owned_by == Globals.Owners.OWNED_BY_COLLAB_PARTNER:
		modified_damage = collab_partner.apply_collab_damage_modifiers(BASE_DAMAGE, modified_damage)

	return modified_damage
