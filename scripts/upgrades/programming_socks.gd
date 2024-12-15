extends UpgradeScene 

@onready var collab_partner = get_parent() as CollabPartner
@onready var ai = get_tree().get_first_node_in_group("ai") as AI

## Override to use. 
func sync_level() -> void:
	match upgrade.lvl: 
		1:
			collab_partner.max_speed = collab_partner.BASE_MAX_SPEED + collab_partner.BASE_MAX_SPEED * 0.05
			ai.max_speed =  ai.BASE_MAX_SPEED + ai.BASE_MAX_SPEED * 0.05
		2: 
			collab_partner.max_speed = collab_partner.BASE_MAX_SPEED + collab_partner.BASE_MAX_SPEED * 0.10
			ai.max_speed = ai.BASE_MAX_SPEED + ai.BASE_MAX_SPEED * 0.10
		3:
			collab_partner.max_speed = collab_partner.BASE_MAX_SPEED + collab_partner.BASE_MAX_SPEED * 0.15
			ai.max_speed =  ai.BASE_MAX_SPEED + ai.BASE_MAX_SPEED * 0.15
		4: 
			collab_partner.max_speed = collab_partner.BASE_MAX_SPEED + collab_partner.BASE_MAX_SPEED * 0.20
			ai.max_speed = ai.BASE_MAX_SPEED + ai.BASE_MAX_SPEED * 0.20
