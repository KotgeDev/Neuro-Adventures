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

func connect_signals() -> void:
	if is_collab:
		Globals.send_collab_upgrades.connect(_on_send_upgrades)
	else:
		Globals.send_ai_upgrades.connect(_on_send_upgrades)

func setup() -> void:
	collab_partner = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)
	ai = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)

	if is_collab:
		title.text = "Collab Partner"
		character = collab_partner

		var t_atk_inc = (StatsManager.atk_inc + StatsManager.collab_atk_inc)
		var t_atk_mult = (StatsManager.atk_mult * StatsManager.collab_atk_mult)
		var t_atk_const = (StatsManager.atk_const + StatsManager.collab_atk_const)
		stats_label.text = (
			"Health: [color=crimson]%.0f[/color] / %.0f\n" % [collab_partner.health, collab_partner.max_health] +
			"Evasion: [color=aqua]%.0f%%[/color]  " % ((StatsManager.evasion + StatsManager.collab_evasion)*100) +
			"Speed: [color=aqua]%.1f[/color]\n" % collab_partner.max_speed +
			"Cooldown Reduction: [color=lime]%.0f%%[/color]\n" % ((StatsManager.cd_reduction + StatsManager.collab_cd_reduction) * 100) +
			"Filter: [color=deepskyblue]%.0f%%[/color]\n" % (StatsManager.filter * 100) +
			"Collection Range Increase: [color=lime]+%.0f%%[/color]\n" % (StatsManager.cr_increase * 100) +
			"Perc. ATK Increase: [color=violet]+%.0f%%[/color]\n" % (t_atk_inc*100) +
			"Multipliers: [color=violet]x%.1f[/color]\n" % t_atk_mult +
			"Constant: [color=violet]%.1f[/color]\n" % t_atk_const +
			"(Final ATK = Base ATK * [color=violet]%.1f[/color] * [color=violet]%.1f[/color] + [color=violet]%.1f[/color])" % [t_atk_inc + 1.0, t_atk_mult, t_atk_const]
		)
	else:
		title.text = "AI"
		character = ai

		var t_atk_inc = (StatsManager.atk_inc + StatsManager.ai_atk_inc)
		var t_atk_mult = (StatsManager.atk_mult * StatsManager.ai_atk_mult)
		var t_atk_const = (StatsManager.atk_const + StatsManager.ai_atk_const)
		stats_label.text = (
			"Health: [color=crimson]%.0f[/color] / %.0f\n" % [ai.health, ai.max_health] +
			"Evasion: [color=aqua]%.0f%%[/color]   " % ((StatsManager.evasion + StatsManager.ai_evasion) * 100) +
			"Speed: [color=aqua]%.1f[/color]\n" % ai.max_speed +
			"Cooldown Reduction: [color=lime]%.0f%%[/color]\n" % ((StatsManager.cd_reduction + StatsManager.ai_cd_reduction) * 100) +
			"Switch Cooldown: [color=lime]%.1fs[/color]\n" % ai.switch_time +
			"Perc. ATK Increase: [color=violet]+%.0f%%[/color]\n" % (t_atk_inc * 100) +
			"Multipliers: [color=violet]x%.1f[/color]\n" % t_atk_mult +
			"Constant: [color=violet]%.1f[/color]\n" % t_atk_const +
			"(Final ATK = Base ATK * [color=violet]%.1f[/color] * [color=violet]%.1f[/color] + [color=violet]%.1f[/color])" % [t_atk_inc + 1.0, t_atk_mult, t_atk_const]
		)

	if is_collab:
		Globals.request_collab_upgrades.emit()
	else:
		Globals.request_ai_upgrades.emit()

func _on_send_upgrades(upgrades: Array) -> void:
	for scene in upgrades:
		var upgrade = scene as Upgrade
		var new_upgrade_square = upgrade_square.duplicate()
		var texture = new_upgrade_square.get_node("TextureRect")
		texture.texture = upgrade.icon

		new_upgrade_square.visible = true
		upgrade_container.add_child(new_upgrade_square)

func close() -> void:
	for child in upgrade_container.get_children():
		child.queue_free()
