extends Control

@export var pause_manager: PauseManager
@export var level_counter: Label
@onready var ntx_label: Label = %NtxLabel
@onready var reroll_container: HBoxContainer = %RerollContainer
@onready var choice_panel_template: Control = $UpgradeChoicePanel
@onready var choice_panel_container: VBoxContainer = %ChoicePanelContainer
@onready var reroll_label: Label = %RerollLabel
var collab_partner: CollabPartner

#region REROLL
const REROLL_PENALTY_INCREMENT := 5
var reroll_count := 0
#endregion

var ui_Active = false
var menu_blip2: AudioStream = preload("res://assets/sfx/menublip2.wav")

func _ready():
	scale = Vector2.ZERO
	Globals.show_three_random_upgrades.connect(_on_show_three_random_upgrades)
	Globals.send_all_existing_upgrades.connect(_on_send_all_existing_upgrades)
	Globals.map_ready.connect(_on_map_ready)

func _on_map_ready() -> void:
	collab_partner = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)

func _on_show_three_random_upgrades(upgrades: Array) -> void:
	level_counter.text = str(collab_partner.lv)

	ntx_label.visible = false
	reroll_container.visible = true

	pause_manager.pause_game()
	display_upgrades(upgrades)

func _on_send_all_existing_upgrades(upgrades: Array) -> void:
	ntx_label.visible = true
	reroll_container.visible = false

	pause_manager.pause_game()
	display_upgrades(upgrades)

func display_upgrades(upgrades: Array) -> void:
	visible = true
	_set_scale_zero()
	ui_Active = true

	for u in upgrades:
		var upgrade = u as Upgrade

		var choice_panel = choice_panel_template.duplicate()
		var button = choice_panel.get_node("Button")
		var v_container = choice_panel.get_node("VBoxContainer")
		var upgrade_name = v_container.get_node("UpgradeName")
		var h_container = v_container.get_node("HBoxContainer")
		var center_container = h_container.get_node("CenterContainer")
		var icon = center_container.get_node("Icon")
		var outline = center_container.get_node("Outline")
		var description = h_container.get_node("Description")

		button.pressed.connect(_on_upgrade_selected.bind(upgrade))
		button.mouse_entered.connect(_on_mouse_over_upgrade)

		if upgrade.unlimited:
			upgrade_name.text = " %s [Unlimited]" % [upgrade.upgrade_name]
		else:
			upgrade_name.text = " %s [Lv%d]" % [upgrade.upgrade_name, upgrade.lvl + 1]
		var settings = SettingsManager.settings as Settings
		if upgrade.upgrade_type == UpgradeResource.UpgradeType.AI_UPGRADE:
			outline.texture = CharacterManager.character_data[settings.ai_selected].icon_outline
		else:
			outline.texture = CharacterManager.character_data[settings.collab_partner_selected].icon_outline
		icon.texture = upgrade.icon
		description.text = upgrade.descriptions[upgrade.lvl]
		choice_panel.visible = true
		choice_panel_container.add_child(choice_panel)

func _on_mouse_over_upgrade() -> void:
	AudioSystem.play_sfx(menu_blip2, Vector2(640 / 2.0, 340 / 2.0))

func _on_upgrade_selected(upgrade: Upgrade) -> void:
	collab_partner.exp_requirement += reroll_count * REROLL_PENALTY_INCREMENT
	reroll_count = 0
	reroll_label.visible = false

	pause_manager.unpause_game()
	AudioSystem.play_sfx(menu_blip2, Vector2(640 / 2.0, 340 / 2.0))
	Globals.lvl_up.emit(upgrade)
	visible = false
	for child in choice_panel_container.get_children():
		child.queue_free()

func _on_reroll_button_pressed():
	reroll_label.visible = true

	for child in choice_panel_container.get_children():
		child.queue_free()

	reroll_count += 1
	reroll_label.text = "Penalty: %d exp" % (reroll_count * REROLL_PENALTY_INCREMENT)

	Globals.request_random_upgrades.emit()

func _set_scale_zero():
	scale = Vector2.ZERO

func _process(delta):
	if ui_Active:
		scale += Vector2.ONE*delta*5
		scale = clamp(scale, Vector2.ZERO, Vector2.ONE)
