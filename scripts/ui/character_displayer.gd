extends Control

@onready var upgrade_panel = $UpgradePanel
@onready var upgrades_container = %UpgradesContainer
@onready var default_upgrades_container = %DefaultUpgradesContainer

var default_upgrades = [] 

# Called when the node enters the scene tree for the first time.
func _ready():
	for upgrade in CharacterInfo.all_ai_db.db:
		add_upgrade_panel(upgrades_container, upgrade)
	for upgrade in CharacterInfo.neuro_upgrades_db.db:
		add_upgrade_panel(upgrades_container, upgrade)
	for upgrade_name in SavedOptions.settings.neuro_default:
		var upgrade = CharacterInfo.find_upgrade(upgrade_name, CharacterInfo.neuro_upgrades_db.db)
		default_upgrades.append(upgrade)
		add_upgrade_panel(default_upgrades_container, upgrade, true)
		remove_upgrade_panel(upgrade, upgrades_container)

func add_upgrade_panel(container: Control, upgrade: UpgradeResource, outline := false) -> void:
	var new_panel = upgrade_panel.duplicate()
	var v_container = new_panel.get_node("VBoxContainer")
	var labels = v_container.get_node("Labels") 
	var title = labels.get_node("Title")
	var view_link = labels.get_node("ViewLink")
	var h_container = v_container.get_node("HBoxContainer")
	var icon = h_container.get_node("IconContainer").get_node("Icon")
	var description = h_container.get_node("Description")
	var button = new_panel.get_node("Button")
	
	button.pressed.connect(_on_upgrade_selected.bind(upgrade))
	
	title.text = upgrade.upgrade_name 
	description.text = upgrade.descriptions[0]
	icon.texture = upgrade.icon
	new_panel.set_meta("upgrade", upgrade)
	
	if outline: 
		new_panel.get_node("DefaultOutline").visible = true
	
	new_panel.visible = true 
	container.add_child(new_panel)	

func _on_upgrade_selected(upgrade: UpgradeResource) -> void:
	if not upgrade in default_upgrades:
		if default_upgrades.size() == 2:
			return 
		
		default_upgrades.append(upgrade)
		
		# Remove panel from upgrades container 
		for child in upgrades_container.get_children():
			if child.get_meta("upgrade") == upgrade:
				child.queue_free() 
		
		add_upgrade_panel(default_upgrades_container, upgrade, true)
	else: 
		default_upgrades.erase(upgrade)
		
		# Remove panel from default upgrades container 
		for child in default_upgrades_container.get_children():
			if child.get_meta("upgrade") == upgrade:
				child.queue_free() 
		
		add_upgrade_panel(upgrades_container, upgrade)

func remove_upgrade_panel(upgrade: UpgradeResource, container: Control) -> void:
	for child in container.get_children():
		if child.get_meta("upgrade") == upgrade:
			child.queue_free() 

func _on_return_button_pressed():
	var new_default_upgrades = []
	
	for upgrade in default_upgrades: 
		new_default_upgrades.append(upgrade.upgrade_name)
	
	SavedOptions.settings.neuro_default = new_default_upgrades
	SavedOptions.save_data()
	
	get_tree().change_scene_to_file("res://scenes/ui/characters_menu.tscn")
