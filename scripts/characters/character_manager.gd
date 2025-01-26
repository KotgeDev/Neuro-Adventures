extends Node

@onready var all_ai_db = preload("res://resources/upgrades/all_ai.tres").db
@onready var all_collab_db = preload("res://resources/upgrades/all_collab.tres").db
@onready var neuro_upgrades_db = preload("res://resources/upgrades/neuro_upgrades_db.tres").db
@onready var vedal_upgrades_db = preload("res://resources/upgrades/vedal_upgrades_db.tres").db
@onready var evil_upgrades_db = preload("res://resources/upgrades/evil_upgrades_db.tres").db
@onready var anny_upgrades_db = preload("res://resources/upgrades/anny_upgrades_db.tres").db

@onready var character_data = {
	Globals.CharacterChoice.NEURO: CharacterData.new(
		"Neuro",  # Name
		neuro_upgrades_db,  # Db
		45,  # Hp
		75,  # Speed
		true,  # is AI
		preload("res://assets/upgrades/icons/neuro_outline.png")  # icon_outline
	),
	Globals.CharacterChoice.VEDAL: CharacterData.new(
		"Vedal",
		vedal_upgrades_db,
		40,
		65,
		false,
		preload("res://assets/upgrades/icons/vedal_outline.png")
	),
	Globals.CharacterChoice.EVIL: CharacterData.new(
		"Evil",
		evil_upgrades_db,
		60,
		50,
		true,
		preload("res://assets/upgrades/icons/evil_outline.png")
	),
	Globals.CharacterChoice.ANNY: CharacterData.new(
		"Anny",
		anny_upgrades_db,
		45,
		60,
		false,
		preload("res://assets/upgrades/icons/anny_outline.png")
	)
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func find_upgrade(upgrade_name: String, db: Array) -> Resource:
	for upgrade in all_ai_db:
		if upgrade.upgrade_name == upgrade_name:
			return upgrade
	for upgrade in all_collab_db:
		if upgrade.upgrade_name == upgrade_name:
			return upgrade
	for upgrade in db:
		if upgrade.upgrade_name == upgrade_name:
			return upgrade
	assert(false, "No upgrade resource named " + upgrade_name)
	return null
