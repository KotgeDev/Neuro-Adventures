extends UpgradeScene

@onready var collab_partner = get_parent() as CollabPartner
@onready var ai = get_tree().get_first_node_in_group("ai") as AI

## Override to use.
func sync_level() -> void:
	match upgrade.lvl:
		1:
			StatsManager.speed_increase += 0.05
		2:
			StatsManager.speed_increase += 0.05
		3:
			StatsManager.speed_increase += 0.05
		4:
			StatsManager.speed_increase += 0.05
