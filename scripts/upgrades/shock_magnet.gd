extends UpgradeScene 

@onready var collab_partner = get_parent() as CollabPartner

func _ready() -> void:
	sync_level() 
	

## Override to use. 
func sync_level() -> void:
	collab_partner._on_powerup_get()
	if upgrade.lvl >= 1:
		collab_partner.pickup_range = collab_partner.BASE_PICKUP_RANGE * 1.30
	if upgrade.lvl >= 2: 
		collab_partner.pickup_range = collab_partner.BASE_PICKUP_RANGE * 1.40
	if upgrade.lvl >= 3: 
		collab_partner.pickup_range = collab_partner.BASE_PICKUP_RANGE * 1.50
