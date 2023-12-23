extends Node2D

func _ready() -> void: 
	Globals.get_random_upgrades.connect(get_random_upgrades)
	Globals.add_specific_upgrades.connect(_on_add_specific_upgrades)
	Globals.lvl_up.connect(_on_lvl_up)

var upgrades_db = [
	Upgrade.new(
		"Programming Socks",
		[
			"+ 20% faster speed for collab partners",
			"+ 40% faster speed for collab partners"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		2,
		0,
		preload("res://scenes/upgrades/programming_socks.tscn")
	),
	
	Upgrade.new(
		"Filter",
		[
			"AIs now do 30% less damage to collab partners",
			"AIs now do 40% less damage to collab partners",
			"AIs now do 50% less damage to collab partners",
			"AIs now do 70% less damage to collab partners"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/filter.tscn")
	)
]

func _on_add_specific_upgrades(upgrades: Array) -> void:
	for upgrade in upgrades:
		upgrades_db.append(upgrade)

func get_random_upgrades() -> void:
	remove_maxed_upgrades()
	
	var temp_upgrades_db = upgrades_db.duplicate() 
	var random_upgrades = []
	
	if temp_upgrades_db.size() < 3: 
		Globals.send_random_upgrades.emit(temp_upgrades_db)
		return
	
	for i in range(3): 
		var random_index = randi() % temp_upgrades_db.size()  
		random_upgrades.append(temp_upgrades_db[random_index])
		temp_upgrades_db.remove_at(random_index)
	
	Globals.send_random_upgrades.emit(random_upgrades)
	
func remove_maxed_upgrades() -> void: 
	var to_remove = [] 
	
	for i in range(upgrades_db.size()): 
		if upgrades_db[i].max_lvl == upgrades_db[i].lvl:
			to_remove.append(i)
	
	for i in to_remove: 
		upgrades_db.remove_at(i)   

func _on_lvl_up(upgrade: Upgrade) -> void: 
	if upgrade.lvl == 0:
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
