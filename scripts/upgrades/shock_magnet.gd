extends UpgradeScene 

@onready var collab_partner = get_parent() as CollabPartner

## Override to use. 
func sync_level() -> void:
	match upgrade.lvl:
		1:
			StatsManager.cr_increase = 0.30
		2: 
			StatsManager.cr_increase = 0.40
		3: 
			StatsManager.cr_increase = 0.50
