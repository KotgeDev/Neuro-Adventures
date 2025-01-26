extends StatsPanel

@export var is_collab := true

@onready var title: Label = $VBoxContainer/Title
@onready var stats_label: RichTextLabel = %StatsLabel
@onready var upgrade_container: GridContainer = $VBoxContainer/HBoxContainer/VBoxContainer/UpgradeGridContainer
@onready var upgrade_square: CenterContainer = $UpgradeGridSquare
var upgrade_manager: UpgradeManager
var collab_partner: CollabPartner
var ai: AI
var character

func setup() -> void:
	collab_partner = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)
	ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)


	if is_collab:
		title.text = "Collab Partner"
		character = collab_partner

		var t_atk_inc = (StatsManager.atk_inc + StatsManager.collab_atk_inc)
		var t_atk_mult = (StatsManager.atk_mult + StatsManager.collab_atk_mult)
		var t_atk_const = (StatsManager.atk_const + StatsManager.collab_atk_const)
		stats_label.text = (
			"Health: %.0f / %.0f\n" % [collab_partner.health, collab_partner.max_health] +
			"Evasion: %.1f%%   " % (StatsManager.evasion + StatsManager.collab_evasion) +
			"Speed: %.1f\n" % collab_partner.max_speed +
			"Cooldown Reduction: %.1f%%\n" % (StatsManager.cd_reduction) +
			"Filter: %.1f%%\n" % StatsManager.filter +
			"Pickup Range: %.1f\n" % collab_partner.pickup_range +
			"Perc. ATK Increase: %.1f%%\n" % t_atk_inc +
			"Multipliers: x%.1f\n" % t_atk_mult +
			"Constant: %.1f\n" % t_atk_const +
			"(Final Dmg = Base Dmg * %.1f * %.1f + %.1f)" % [t_atk_inc + 1.0, t_atk_mult, t_atk_const]
		)
	else:
		title.text = "AI"
		character = ai

		var t_atk_inc = (StatsManager.atk_inc + StatsManager.ai_atk_inc)
		var t_atk_mult = (StatsManager.atk_mult + StatsManager.ai_atk_mult)
		var t_atk_const = (StatsManager.atk_const + StatsManager.ai_atk_const)
		stats_label.text = (
			"Health: %.0f / %.0f\n" % [ai.health, ai.max_health] +
			"Evasion: %.1f%%   " % (StatsManager.evasion + StatsManager.ai_evasion) +
			"Speed: %.1f\n" % ai.max_speed +
			"Cooldown Reduction: %.1f%%\n" % (StatsManager.cd_reduction) +
			"Switch Cooldown: %.1fs\n" % ai.switch_time +
			"Perc. ATK Increase: %.1f%%\n" % t_atk_inc +
			"Multipliers: x%.1f\n" % t_atk_mult +
			"Constant: %.1f\n" % t_atk_const +
			"(Final Dmg = Base Dmg * %.1f * %.1f + %.1f)" % [t_atk_inc + 1.0, t_atk_mult, t_atk_const]
		)

	upgrade_manager = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME).get_node("UpgradeManager") as UpgradeManager
	for value in upgrade_manager.existing_upgrades:
		var upgrade = value as Upgrade
		var new_upgrade_square = upgrade_square.duplicate()
		var texture = new_upgrade_square.get_node("TextureRect")
		texture = upgrade.icon
		upgrade_container.add_child(new_upgrade_square)
