extends Node2D

func _ready() -> void: 
	Globals.get_random_upgrades.connect(get_random_upgrades)
	Globals.lvl_up.connect(lvl_up)
	Globals.map_ready.connect(_on_map_ready)

## character specific upgrades should be merged into this array
## Upgrades in this array will be included in the game
## regardless of the characters used. Character specific upgrades
## will only be included if that specific character is used. 
## The first upgrade in a character specific upgrades database will
## be used as the default weapon. 
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
		"Shock Magnet",
		[
			"33% larger item collection range for collab partners",
			"66% larger item collection range for collab partners",
			"2x larger item collection range for collab partners",
			"4x larger item collection range for collab partners"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/shock_magnet.tscn")
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

var neuro_upgrades_db = [
	Upgrade.new(
		"Dual Strike", 
		[
			"Dual Strike",
			"Less interval between strikes",
			"Higher damage per strike",
			"Greater strike range",
			"Even Less interval between strikes"
		], 
		Globals.UpgradeType.AI_UPGRADE, 
		5, 
		0,
		preload("res://scenes/upgrades/dual_strike_scene.tscn")
	), 
	Upgrade.new(
		"Gymbag Drone",
		[
			"A gymbag drone that will strike enemies at random. You can have many as you want."
		],
		Globals.UpgradeType.AI_UPGRADE, 
		1,
		0,
		preload("res://scenes/upgrades/gymbag_drone.tscn")
	),
	Upgrade.new(
		"Gaslight",
		[
			"Gives the AI 5% chance to ignore damage and 10% chance to divert the damage to the Collab Partner",
			"Gives the AI 7% chance to ignore damage and 15% chance to divert the damage to the Collab Partner",
			"Gives the AI 10% chance to ignore damage and 20% chance to divert the damage to the Collab Partner",
			"Gives the AI 30% chance to ignore damage and 50% chance to divert the damage to the Collab Partner"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/gaslight.tscn")
	)
]

var vedal_upgrades_db = [
	Upgrade.new(
		"Rum",
		[
			"Rum", 
			"Rum now does splash damage upon impact",
			"Decreased interval between fire",
			"Splash damage lasts longer and deals more frequent damage"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/rum_scene.tscn")
	),
	Upgrade.new(
		"Copy and Paste",
		[
			"10 % chance for AI and collab partner to deal double damage",
			"15 % chance for AI and collab partner to deal double damage",
			"20 % chance for AI and collab partner to deal double damage",
			"25 % chance for AI and collab partner to deal double damage",
			"40 % chance for AI and collab partner to deal double damage",
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		5,
		0,
		preload("res://scenes/upgrades/copy_and_paste.tscn")
	)
]

func _on_map_ready() -> void:
	var collab_partner_db: Array
	var ai_db: Array
	
	match Globals.current_collab_partner:
		Globals.WhichCollabPartner.VEDAL: collab_partner_db = vedal_upgrades_db

	match Globals.current_ai: 
		Globals.WhichAI.NEURO: ai_db = neuro_upgrades_db
	
	merge_character_upgrade_db(collab_partner_db) 
	lvl_up(collab_partner_db[0])
	
	merge_character_upgrade_db(ai_db) 
	lvl_up(ai_db[0])

func merge_character_upgrade_db(upgrades: Array) -> void:
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

func lvl_up(upgrade: Upgrade) -> void: 
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
