extends CollabPartner  

@export_category("Vedal")
@export var STARTING_UPGRADE := 0

var upgrades_db: Array[Upgrade] = [
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

func specific_setup() -> void: 
	Globals.add_specific_upgrades.emit(upgrades_db) 
	Globals.lvl_up.emit(upgrades_db[STARTING_UPGRADE])

func apply_global_damage_modifiers_specific(BASE_DAMAGE: float, modified_damage: float) -> float:
	var copy_and_paste = get_node_or_null("CopyAndPaste")
	if copy_and_paste: 
		match copy_and_paste.upgrade.lvl: 
			1:
				modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 10)
			2:
				modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 15)
			3:
				modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 20)
			4:
				modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 25)
			5:
				modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 40)
	
	return modified_damage 

func get_copy_paste_damage(BASE_DAMAGE: float, modified_damage: float, percent_chance) -> float:
	var random_int = randi_range(1, 100)
	
	if random_int <= percent_chance: 
		modified_damage = modified_damage + BASE_DAMAGE 
	
	return modified_damage 
