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

func _on_map_ready() -> void:
	add_upgrades_to_pool(CharacterInfo.all_ai_db)
	add_upgrades_to_pool(CharacterInfo.all_collab_db)
	
	match SavedOptions.settings.collab_partner_selected:
		Globals.CharacterChoice.VEDAL: 
			add_upgrades_to_pool(CharacterInfo.vedal_upgrades_db) 
			lvl_up(find_upgrade("Rum"))
			lvl_up(find_upgrade("Creggs"))
		Globals.CharacterChoice.ANNY:
			add_upgrades_to_pool(CharacterInfo.anny_upgrades_db)
			lvl_up(find_upgrade("Star"))
			lvl_up(find_upgrade("Portal"))

	match SavedOptions.settings.ai_selected: 
		Globals.CharacterChoice.NEURO: 
			add_upgrades_to_pool(CharacterInfo.neuro_upgrades_db) 
			lvl_up(find_upgrade("Dual Strike"))
			lvl_up(find_upgrade("Cookies"))
			
		Globals.CharacterChoice.EVIL: 
			add_upgrades_to_pool(CharacterInfo.evil_upgrades_db) 
			lvl_up(find_upgrade("Knife"))
			lvl_up(find_upgrade("Soul Stealer"))
		
			
func find_upgrade(upgrade_name: String) -> Upgrade: 
	for upgrade in upgrades_pool: 
		if upgrade.upgrade_name == upgrade_name:
			return upgrade 
	push_error("No upgrade node named ", upgrade_name)
	return null 

func add_upgrades_to_pool(upgrades: UpgradeDB) -> void:
	for data in upgrades.db:
		var upgrade_res: UpgradeResource = data 
		var upgrade_obj = Upgrade.new(
			upgrade_res.upgrade_name,
			upgrade_res.icon,
			upgrade_res.description,
			upgrade_res.upgrade_type, 
			upgrade_res.max_lvl,
			0, 
			upgrade_res.scene_template, 
			upgrade_res.tags
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
		
		if upgrade.upgrade_type == Globals.UpgradeType.AI_UPGRADE:
			Globals.add_upgrade_to_ai.emit(scene)
		elif upgrade.upgrade_type == Globals.UpgradeType.COLLAB_PARTNER_UPGRADE:
			Globals.add_upgrade_to_collab_partner.emit(scene)	

	else: 
		upgrade.lvl += 1 
		upgrade.scene.sync_level()  
