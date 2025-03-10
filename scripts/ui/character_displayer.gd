extends Control
class_name CharacterDisplayer

signal close

@onready var upgrade_panel = $UpgradePanel
@onready var upgrades_container = %UpgradesContainer
@onready var default_upgrades_container = %DefaultUpgradesContainer
@onready var buffer_1 = %Buffer1
@onready var buffer_2 = %Buffer2
@onready var description_label = %DescriptionLabel
@onready var character_name = %CharacterName
@onready var type_label = %TypeLabel
@onready var lvls_container = %LvlsContainer
@onready var lvl_panel = $LvlPanel
@onready var level_viewer = $LevelViewer

var character: Globals.CharacterChoice
var upgrades_db
var shared_upgrades_db
var data: CharacterData
var saved_defaults

var default_upgrades = []

## Requires node to have a _on_close function
static func create(node: Control, character: Globals.CharacterChoice) -> void:
	var scene = load("res://scenes/ui/character_displayer.tscn").instantiate()
	scene.character = character
	node.add_child(scene)
	scene.close.connect(node._on_close)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Render Description
	data = CharacterManager.character_data[character]
	description_label.text = "HP: %d\nSpeed: %d" \
		% [int(data.hp), int(data.speed)]
	character_name.text = data.character_name
	if data.is_ai:
		type_label.text = "AI"
	else:
		type_label.text = "Collab Partner"

	# Render Upgrades
	upgrades_db = data.db
	if data.is_ai:
		shared_upgrades_db = CharacterManager.all_ai_db
	else:
		shared_upgrades_db = CharacterManager.all_collab_db

	saved_defaults = SettingsManager.default_upgrades[character]

	for upgrade in shared_upgrades_db:
		add_upgrade_panel(upgrades_container, upgrade)
	for upgrade in upgrades_db:
		add_upgrade_panel(upgrades_container, upgrade)
	for upgrade_name in saved_defaults:
		var upgrade = CharacterManager.find_upgrade(upgrade_name, upgrades_db)
		default_upgrades.append(upgrade)
		add_upgrade_panel(default_upgrades_container, upgrade, true)
		remove_upgrade_panel(upgrade, upgrades_container)
		update_buffers()

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if level_viewer.visible:
			_on_level_viewer_close()
		else:
			_on_return_button_pressed()

func add_upgrade_panel(container: Control, upgrade: UpgradeResource, outline := false) -> void:
	var new_panel = upgrade_panel.duplicate()
	var v_container = new_panel.get_node("VBoxContainer")
	var labels = v_container.get_node("Labels")
	var title = labels.get_node("Title")
	var view_link = labels.get_node("ViewLink")
	var h_container = v_container.get_node("HBoxContainer")
	var icon = h_container.get_node("IconContainer").get_node("Icon")
	var icon_outline = h_container.get_node("IconContainer").get_node("Outline")
	var description = h_container.get_node("Description")
	var button = new_panel.get_node("Button")

	button.pressed.connect(_on_upgrade_selected.bind(upgrade))

	icon_outline.texture = CharacterManager.character_data[character].icon_outline
	title.text = upgrade.upgrade_name
	description.text = upgrade.descriptions[0]
	icon.texture = upgrade.icon
	new_panel.set_meta("upgrade", upgrade)

	view_link.meta_clicked.connect(_on_view_lvls_clicked.bind(upgrade))

	if outline:
		new_panel.get_node("DefaultOutline").visible = true

	new_panel.visible = true
	container.add_child(new_panel)

func _on_view_lvls_clicked(meta: String, upgrade: UpgradeResource) -> void:
	level_viewer.visible = true

	var loop_count

	if upgrade.upgrade_type == UpgradeResource.UpgradeType.DRONE_UPGRADE:
		loop_count = 1
	else:
		loop_count = upgrade.max_lvl

	for lvl in range(loop_count):
		add_lvl_panel(upgrade, lvl)

func add_lvl_panel(upgrade: UpgradeResource, lvl: int) -> void:
	var new_panel = lvl_panel.duplicate()
	var v_container = new_panel.get_node("VBoxContainer")
	var labels = v_container.get_node("Labels")
	var title = labels.get_node("Title")
	var h_container = v_container.get_node("HBoxContainer")
	var icon = h_container.get_node("IconContainer").get_node("Icon")
	var outline = h_container.get_node("IconContainer").get_node("Outline")
	var description = h_container.get_node("Description")

	if upgrade.upgrade_type == UpgradeResource.UpgradeType.DRONE_UPGRADE:
		title.text = " %s" % [upgrade.upgrade_name]
		description.text = upgrade.descriptions[0]
	else:
		title.text = " %s [Lv%d]" % [upgrade.upgrade_name, lvl + 1]
		description.text = upgrade.descriptions[lvl]
	outline.texture = CharacterManager.character_data[character].icon_outline
	icon.texture = upgrade.icon

	new_panel.visible = true
	lvls_container.add_child(new_panel)

func _on_upgrade_selected(upgrade: UpgradeResource) -> void:
	if not upgrade in default_upgrades:
		if default_upgrades.size() == 2:
			return

		default_upgrades.append(upgrade)
		remove_upgrade_panel(upgrade, upgrades_container)
		add_upgrade_panel(default_upgrades_container, upgrade, true)
	else:
		default_upgrades.erase(upgrade)
		remove_upgrade_panel(upgrade, default_upgrades_container)
		add_upgrade_panel(upgrades_container, upgrade)

	update_buffers()

func update_buffers() -> void:
	if default_upgrades.size() == 2:
		buffer_1.visible = true
		buffer_2.visible = true
	elif default_upgrades.size() == 1:
		buffer_1.visible = true
		buffer_2.visible = false
	else:
		buffer_1.visible = false
		buffer_2.visible = false

func remove_upgrade_panel(upgrade: UpgradeResource, container: Control) -> void:
	for child in container.get_children():
		if child.has_meta("upgrade") and child.get_meta("upgrade") == upgrade:
			child.queue_free()

func _on_return_button_pressed():
	var new_default_upgrades = []

	for upgrade in default_upgrades:
		new_default_upgrades.append(upgrade.upgrade_name)

	SettingsManager.default_upgrades[character] = new_default_upgrades
	SettingsManager.save_default_upgrades.emit()

	close.emit()
	queue_free()

func _on_level_viewer_close():
	level_viewer.visible = false
	for child in lvls_container.get_children():
		child.queue_free()
