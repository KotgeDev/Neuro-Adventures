extends Node2D
class_name UpgradeManager

func _ready() -> void: 
	Globals.get_random_upgrades.connect(get_random_upgrades)
	Globals.get_all_existing_upgrades.connect(get_all_existing_upgrades)
	Globals.lvl_up.connect(lvl_up)
	Globals.map_ready.connect(_on_map_ready)
	Globals.remove_maxed_upgrades.connect(remove_maxed_upgrades)

var upgrades_pool = []
var existing_upgrades = []
var ai_selected
var collab_selected 

func _on_map_ready() -> void:
	add_upgrades_to_pool(CharacterManager.all_ai_db)
	add_upgrades_to_pool(CharacterManager.all_collab_db)
	
	ai_selected = SettingsManager.settings.ai_selected
	collab_selected = SettingsManager.settings.collab_partner_selected
	
	add_upgrades_to_pool(CharacterManager.character_data[ai_selected].db)
	lvl_up(find_upgrade(SettingsManager.default_upgrades[ai_selected][0]))
	lvl_up(find_upgrade(SettingsManager.default_upgrades[ai_selected][1]))
	
	add_upgrades_to_pool(CharacterManager.character_data[collab_selected].db)
	lvl_up(find_upgrade(SettingsManager.default_upgrades[collab_selected][0]))
	lvl_up(find_upgrade(SettingsManager.default_upgrades[collab_selected][1]))	
			
func find_upgrade(upgrade_name: String) -> Upgrade: 
	for upgrade in upgrades_pool: 
		if upgrade.upgrade_name == upgrade_name:
			return upgrade 
	push_error("No upgrade node named ", upgrade_name)
	return null 

func add_upgrades_to_pool(upgrades: Array) -> void:
	for data in upgrades:
		var upgrade_res: UpgradeResource = data 
		var upgrade_obj = Upgrade.new(
			upgrade_res.upgrade_name,
			upgrade_res.icon,
			upgrade_res.descriptions,
			upgrade_res.upgrade_type, 
			upgrade_res.max_lvl,
			0, 
			upgrade_res.scene_template, 
			upgrade_res.unlimited,
			upgrade_res.tag
		)
		upgrades_pool.append(upgrade_obj)

func get_random_upgrades() -> void:
	remove_maxed_upgrades()
	
	var temp_upgrades_db = upgrades_pool.duplicate() 
	var random_upgrades = []
	
	if temp_upgrades_db.size() < 3: 
		Globals.send_random_upgrades.emit(temp_upgrades_db)
		return
	
	for i in range(3): 
		var random_index = randi() % temp_upgrades_db.size()  
		random_upgrades.append(temp_upgrades_db[random_index])
		temp_upgrades_db.remove_at(random_index)
	
	Globals.send_random_upgrades.emit(random_upgrades)

## Ensure to emit remove maxed upgrades 
## before using this function
func get_all_existing_upgrades() -> void:
	Globals.send_all_existing_upgrades.emit(existing_upgrades)

func remove_maxed_upgrades() -> void: 
	var to_remove = [] 
	
	for upgrade in upgrades_pool:
		if upgrade.max_lvl == upgrade.lvl: 
			to_remove.append(upgrade) 
	
	for upgrade in to_remove:
		existing_upgrades.erase(upgrade)
		upgrades_pool.erase(upgrade)

func lvl_up(upgrade: Upgrade) -> void: 
	if upgrade.lvl == 0:
		if not existing_upgrades.has(upgrade):
			existing_upgrades.append(upgrade)
		
		upgrade.lvl = 1
		var scene = upgrade.scene_template.instantiate() 
		#WARNING: Cyclic reference. Should be allowed in godot 4.2 though 
		# adding a warning just in case 
		upgrade.scene = scene 
		scene.upgrade = upgrade
		
		if upgrade.upgrade_type == UpgradeResource.UpgradeType.AI_UPGRADE:
			Globals.add_upgrade_to_ai.emit(scene)
		elif upgrade.upgrade_type == UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			Globals.add_upgrade_to_collab_partner.emit(scene)	
	else: 
		upgrade.lvl += 1 

	upgrade.scene.sync_level()  
