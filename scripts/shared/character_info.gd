extends Node

@onready var all_ai_db = preload("res://resources/upgrades/all_ai.tres")
@onready var all_collab_db = preload("res://resources/upgrades/all_collab.tres")
@onready var neuro_upgrades_db = preload("res://resources/upgrades/neuro_upgrades_db.tres")

var evil_upgrades_db = [
	Upgrade.new(
		"Knife", 
		preload("res://assets/upgrades/knife_icon.png"),
		[
			"Knife",
			"Less interval between strikes",
			"More damage per strike",
			"Increased range",
			"Even less interval between strikes",
			"Increased range. Warning, this range equals Evil's default distance from the collab partner."
		], 
		Globals.UpgradeType.AI_UPGRADE, 
		6, 
		0,
		preload("res://scenes/upgrades/knife_scene.tscn")
	),
	Upgrade.new(
		"Summon Circle", 
		preload("res://assets/upgrades/summon_circle_icon.png"),
		[
			"Summon circle. Will slow all enemies within range by 20%",
			"Will slow all enemies within range by 30% ",
			"Will slow all enemies within range by 40%",
			"Increase range of summon circle",
			"Will slow all enemies within range by 50%",
			"Will slow all enemies within range by 60%"
		], 
		Globals.UpgradeType.AI_UPGRADE, 
		6, 
		0,
		preload("res://scenes/upgrades/summon_circle.tscn")
	),
	Upgrade.new(
		"Soul Stealer",
		preload("res://assets/upgrades/soul_stealer_circle_icon.png"),
		[
			"Everytime Evil deals damage, she will gain 1% of the damage dealt as HP",
			"Everytime Evil deals damage, she will gain 2% of the damage dealt as HP",
			"Everytime Evil deals damage, she will gain 3% of the damage dealt as HP",
			"Everytime Evil deals damage, she will gain 5% of the damage dealt as HP"
		],
		Globals.UpgradeType.AI_UPGRADE,
		4,
		0,
		preload("res://scenes/upgrades/soul_stealer.tscn")
	),
	Upgrade.new(
		"Forgotten Child",
		preload("res://assets/upgrades/forgotten_child_icon.png"),
		[
			"Both characters have + 50% of base damage. Evil will stay further away from you",
			"Both characters have + 100% of base damage. Evil will stay even further away from you",
			"Both characters have + 200% of base damage. ReallyGunPull turtle ReallyGunPull turtle"
		],
		Globals.UpgradeType.AI_UPGRADE,
		3,
		0,
		preload("res://scenes/upgrades/forgotten_child.tscn")
	),
	Upgrade.new(
		"Pizza",
		preload("res://assets/upgrades/pizza_icon.png"),
		[
			"A pineapple pizza will target enemies closest to Evil."
		],
		Globals.UpgradeType.AI_UPGRADE, 
		1,
		0,
		preload("res://scenes/upgrades/pizza.tscn"),
		["unlimited"]
	),
	Upgrade.new(
		"Viva La Pizza Revolution!",
		preload("res://assets/upgrades/viva_la_pizza_revolution_icon.png"),
		[
			"Increase speed of all pizza by 30% of base",
			"Increase damage of all pizza by 50% of base",
			"Increase speed of all pizza by 50% of base",
			"Increase damage of all pizza by 150% of base"
		],
		Globals.UpgradeType.AI_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/viva_la_pizza_rev.tscn")
	),
	Upgrade.new(
		"Fireball",
		preload("res://assets/upgrades/fireball_icon.png"),
		[
			"Evil fires a fireball in 4 directions every 2s that can pierce up to 2 enemies",
			"Fireball fire cooldown is reduced to 1.5s",
			"Evil fires a fireball in 6 directions that can pierce up to 3 enemies",
			"Fireball damage is increased by 100%",
			"Evil fires a fireball in 8 directions that can pierce up to 4 enemies",
			"Evil becomes a 2hu character. Warning, dangerous upgrade."
		],
		Globals.UpgradeType.AI_UPGRADE,
		6,
		0,
		preload("res://scenes/upgrades/fireball_scene.tscn")
	)
]

var vedal_upgrades_db = [
	Upgrade.new(
		"Rum",
		preload("res://assets/upgrades/rum_icon.png"),
		[
			"Rum", 
			"Rum splash will stun all enemies stepping in for 1s",
			"Rum fire rate is increased",
			"Rum splash lasts longer and deals more frequent damage",
			"Rum splash will stun all enemies stepping in for 3s"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		5,
		0,
		preload("res://scenes/upgrades/rum_scene.tscn")
	),
	Upgrade.new(
		"DM Allegations",
		preload("res://assets/upgrades/dm_allegations_icon.png"),
		[
			"Press [space] for Vedal to become immune for 0.4s. Pink notif means ability is ready",
			"Cooldown is reduced to 4s",
			"Immunity duration increased to 0.6s",
			"Cooldown is reduced to 3s",
			"Cooldown is reduced to 2s"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE,
		4,
		0,
		preload("res://scenes/upgrades/dm_allegations.tscn")
	),
	Upgrade.new(
		"Creggs",
		preload("res://assets/upgrades/creggs_icon.png"),
		[
			"1% chance for enemies to drop a chicken bake (Gives 7 HP to the Collab Partner)",
			"2% chance for enemies to drop chicken bake ",
			"3% chance for enemies to drop chicken bake ",
			"5% chance for enemies to drop chicken bake"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/creggs_upgrade.tscn")
	)
]

var anny_upgrades_db = [
	Upgrade.new(
		"Star",
		preload("res://assets/upgrades/star_icon.png"),
		[
			"A spinning star spawns and orbits Anny every 2.5s that deals 2 damage. Stars do double damage after 10s",
			"Interval decreases to 2.0s",
			"Damage increases to 3", 
			"Interval decreases to 1.5s",
			"Stars deal double damage after 5s",
			"Damage increases to 4" 
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		6,
		0,
		preload("res://scenes/upgrades/star_upgrade.tscn")
	),
	Upgrade.new(
		"Portal",
		preload("res://assets/upgrades/portal_icon.png"),
		[
			"Press [space] for Anny to teleport to the location of the mouse cursor. Cooldown proportional to distance teleported",
			"Reduce base cooldown to 10s",
			"Reduce base cooldown to 8s",
			"Reduce base cooldown to 6s",
			"Reduce base cooldown to 5s"
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		5,
		0,
		preload("res://scenes/upgrades/portal_upgrade.tscn")
	),
	Upgrade.new(
		"Orange",
		preload("res://assets/upgrades/orange_icon.png"),
		[
			"Anny has regen which is increased for 30s by collecting an orange with a 1% drop chance",
			"2% chance for enemies to drop an orange ",
			"3% chance for enemies to drop an orange ",
			"5% chance for enemies to drop an orange "
		],
		Globals.UpgradeType.COLLAB_PARTNER_UPGRADE, 
		4,
		0,
		preload("res://scenes/upgrades/orange_upgrade.tscn")
	)
]

func find_upgrade(upgrade_name: String, db: Array) -> Resource: 
	for upgrade in all_ai_db.db: 
		if upgrade.upgrade_name == upgrade_name:
			return upgrade 
	for upgrade in all_collab_db.db: 
		if upgrade.upgrade_name == upgrade_name:
			return upgrade 
	for upgrade in db: 
		if upgrade.upgrade_name == upgrade_name:
			return upgrade 
	push_error("No upgrade resource named ", upgrade_name)
	return null 
