extends Node2D

func _ready() -> void: 
	Globals.get_random_upgrades.connect(get_random_upgrades)
	Globals.get_all_existing_upgrades.connect(get_all_existing_upgrades)
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
		preload("res://assets/upgrades/programming_socks_icon.png"),
		[
			"+ 5% faster speed (for both characters)",
			"+ 10% faster speed (for both characters)",
			"+ 15% faster speed (for both characters)",
			"+ 20% faster speed (for both characters)"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/programming_socks.tscn")
	),
	Upgrade.new(
		"Shock Magnet",
		preload("res://assets/upgrades/shock_magnet_icon.png"),
		[
			"33% larger item collection range for collab partners",
			"66% larger item collection range for collab partners",
			"200% larger item collection range for collab partners",
			"400% larger item collection range for collab partners"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/shock_magnet.tscn")
	),
	Upgrade.new(
		"Filter",
		preload("res://assets/upgrades/filtered_icon.png"),
		[
			"AIs now do 30% less damage to collab partners",
			"AIs now do 50% less damage to collab partners",
			"AIs now do 75% less damage to collab partners",
			"AIs now do 90% less damage to collab partners"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/filter.tscn")
	),
	Upgrade.new(
		"Creggs",
		preload("res://assets/upgrades/creggs_icon.png"),
		[
			"1% chance for enemies to drop a chicken bake (Gives 6 HP to the Collab Partner)",
			"2% chance for enemies to drop chicken bake ",
			"3% chance for enemies to drop chicken bake ",
			"5% chance for enemies to drop chicken bake"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/creggs_upgrade.tscn")
	),
	Upgrade.new(
		"Cookies",
		preload("res://assets/upgrades/cookies_icon.png"),
		[
			"1% chance for enemies to drop cookies (Gives 5 HP to the AI)",
			"2% chance for enemies to drop cookies ",
			"3% chance for enemies to drop cookies ",
			"5% chance for enemies to drop cookies"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/cookies_upgrade.tscn")
	),
	Upgrade.new(
		"iNuke6000",
		preload("res://assets/upgrades/inuke6000_icon.png"),
		[
			"iNuke6000s are dropped at a random enemy in range every 6 s dealing splash damage of 12",
			"Nuke launch time is reduced",
			"Two nukes are launched at a time",
			"Nuke launch time is further reduced  ",
			"Three nukes are launched at a time"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		5,
		0,
		preload("res://scenes/upgrades/inuke6000.tscn")
	),	
]

var neuro_upgrades_db = [
	Upgrade.new(
		"Dual Strike", 
		preload("res://assets/upgrades/swords_icon.png"),
		[
			"Dual Strike",
			"Less interval between strikes ",
			"Double damage per strike",
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
		preload("res://assets/upgrades/gymbag_drone_icon.png"),
		[
			"A gymbag drone that will strike enemies at random. You can have many as you want."
		],
		Globals.UpgradeType.AI_UPGRADE, 
		1,
		0,
		preload("res://scenes/upgrades/gymbag_drone.tscn"),
		["unlimited"]
	),
	Upgrade.new(
		"Swarm Upgrades",
		preload("res://assets/upgrades/swarm_upgrades_icon.png"),
		[
			"Increase damage of all gymbag drones by 100% of base",
			"Increase speed of all gymbag drones by 50% of base",
			"Increase damage of all gymbag drones by 200% of base",
			"Increase speed of all gymbag drones by 100% of base"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/swarm_upgrades.tscn")
	),
	Upgrade.new(
		"Gaslight",
		preload("res://assets/upgrades/gaslight_icon.png"),
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
	),
	Upgrade.new(
		"Say it Back!",
		preload("res://assets/upgrades/say_it_back_icon.png"),
		[
			"Both characters have 50% increased damage. The AI will chase after you closer",
			"Both characters have 100% increased damage. The AI will chase after you even closer",
			"Both characters have 150% increased damage. The AI will chase after you like never before."
		],
		Globals.UpgradeType.AI_UPGRADE, 
		3,
		0,
		preload("res://scenes/upgrades/say_it_back.tscn")
	),
	Upgrade.new(
		"Angel Wings",
		preload("res://assets/upgrades/angel_wings_icon.png"),
		[
			"Feathers shoot out from Neuro that target enemies",
			"Feathers can pierce through up to three enemies",
			"Increased fire rate of feathers",
			"Increased damage of feathers",
			"Two feathers are shot at once"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		5,
		0,
		preload("res://scenes/upgrades/angel_wings.tscn")
	)
]

var vedal_upgrades_db = [
	Upgrade.new(
		"Rum",
		preload("res://assets/upgrades/rum_icon.png"),
		[
			"Rum", 
			"Rum splash lasts longer",
			"Decreased interval between fire",
			"Rum splash lasts longer and deals more frequent damage"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/rum_scene.tscn")
	),
	Upgrade.new(
		"DM Allegations",
		preload("res://assets/upgrades/dm_allegations_icon.png"),
		[
			"Vedal ignores 50% of damage, but ignored damage is accumulated with a 0.2% chance of being inflicted at once",
			"Vedal ignores 75% of damage, but ignored damage is accumulated with a 0.3% chance of being inflicted at once", 
			"Vedal ignores 100% of damage, but ignored damage is accumulated with a 0.5% chance of being inflicted at once"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		3,
		0,
		preload("res://scenes/upgrades/dm_allegations.tscn")
	)
]

var existing_upgrades = []

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

func get_all_existing_upgrades() -> void:
	remove_maxed_upgrades()
	Globals.send_all_existing_upgrades.emit(existing_upgrades)

func remove_maxed_upgrades() -> void: 
	var to_remove = [] 
	
	for upgrade in upgrades_db:
		if upgrade.max_lvl == upgrade.lvl: 
			to_remove.append(upgrade) 
	
	for upgrade in to_remove:
		existing_upgrades.erase(upgrade)
		upgrades_db.erase(upgrade)

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
