extends UpgradeScene 

@onready var collab_partner = get_parent() as CollabPartner
@onready var ai = get_tree().get_first_node_in_group("ai") as AI

func _ready() -> void:
	sync_level() 

## Override to use. 
func sync_level() -> void:
	if upgrade.lvl >= 1:
		collab_partner.max_speed += collab_partner.BASE_MAX_SPEED * 0.10
		ai.max_speed += ai.BASE_MAX_SPEED * 0.10
	if upgrade.lvl >= 2: 
		collab_partner.max_speed += collab_partner.BASE_MAX_SPEED * 0.20
		ai.max_speed += ai.BASE_MAX_SPEED * 0.20
