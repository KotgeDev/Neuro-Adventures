## Parent class for all upgrade scenes.
## Upgrade scenes must be added as a direct child to either
## Collab Partners or AIs
## All upgrade properties that require balancing
## should be mutable from the UpgradeScene
## inspector through export variables
extends Node2D
class_name UpgradeScene

var upgrade: Upgrade

## Override to use.
func sync_level() -> void:
	pass

## Override to use
func get_data() -> String:
	return ""

# Helper functions for get_data()
func get_atk_str(damage: float, label := "ATK") -> String:
	var mdf_damage: float

	match upgrade.res.upgrade_type:
		UpgradeResource.UpgradeType.AI_UPGRADE:
			mdf_damage = StatsManager.get_final_ai_atk(damage)
		UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			mdf_damage = StatsManager.get_final_drone_atk(damage)
		UpgradeResource.UpgradeType.DRONE_UPGRADE:
			mdf_damage = StatsManager.get_final_collab_atk(damage)

	return (
		"%s: %.2f" % [label, mdf_damage]
	)


func get_cd_str(cooldown: float, label := "Cooldown") -> String:
	var mdf_cooldown: float

	match upgrade.res.upgrade_type:
		UpgradeResource.UpgradeType.AI_UPGRADE:
			mdf_cooldown = StatsManager.get_final_ai_cd(cooldown)
		UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			mdf_cooldown = StatsManager.get_final_collab_cd(cooldown)
	return (
		"%s: %.2fs" % [label, cooldown]
	)

func get_pierce_str(pierce: int) -> String:
	return (
		"Pierce: %d" % pierce
	)

func get_general_str(_name: String, value: int) -> String:
	return (
		"%s: %d" % [_name, value]
	)

func get_time_str(_name: String, value: int) -> String:
	return (
		"%s: %ds" % [_name, value]
	)

func get_perc_str(_name: String, value: float) -> String:
	return (
		"%s: %.0f%%" % [_name, value * 100]
	)
