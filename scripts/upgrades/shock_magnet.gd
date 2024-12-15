extends UpgradeScene 

@onready var collab_partner = get_parent() as CollabPartner

## Override to use. 
func sync_level() -> void:
	collab_partner._on_powerup_get()
	
	match upgrade.lvl:
		1:
			collab_partner.pickup_range = collab_partner.BASE_PICKUP_RANGE * 1.30
		2: 
			collab_partner.pickup_range = collab_partner.BASE_PICKUP_RANGE * 1.40
		3: 
			collab_partner.pickup_range = collab_partner.BASE_PICKUP_RANGE * 1.50
