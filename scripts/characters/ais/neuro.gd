extends AI

@export_category("Neuro")
@export var STARTING_UPGRADE := 0

var upgrades_db = [
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

func specific_setup() -> void:
	Globals.add_specific_upgrades.emit(upgrades_db) 
	Globals.lvl_up.emit(upgrades_db[STARTING_UPGRADE])

func process_damage_recieved_specific(BASE_DAMAGE: float, modified_damage: float) -> float:	
	var gaslight = get_node_or_null("Gaslight")
	if gaslight:
		match gaslight.upgrade.lvl: 
			1:
				modified_damage = get_gaslight_damage(modified_damage, 5, 10)
			2:
				modified_damage = get_gaslight_damage(modified_damage, 7, 15) 
			3:
				modified_damage = get_gaslight_damage(modified_damage, 10, 20)
			4:   
				modified_damage = get_gaslight_damage(modified_damage, 10, 20)
	
	return modified_damage

func get_gaslight_damage(damage: float, ignore_chance: int, divert_chance:int) -> float: 
	var random_int = randi_range(1, 100)
	
	if random_int <= ignore_chance: 
		damage = 0.0
	elif ignore_chance < random_int and random_int <= (ignore_chance + divert_chance):
		Globals.damage_collab_partner.emit(damage)
		damage = 0.0 
	return damage 

