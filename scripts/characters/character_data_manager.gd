extends Node

@onready var all_ai_db = preload("res://resources/upgrades/all_ai.tres").db
@onready var all_collab_db = preload("res://resources/upgrades/all_collab.tres").db
@onready var neuro_upgrades_db = preload("res://resources/upgrades/neuro_upgrades_db.tres").db
@onready var vedal_upgrades_db = preload("res://resources/upgrades/vedal_upgrades_db.tres").db
@onready var evil_upgrades_db = preload("res://resources/upgrades/evil_upgrades_db.tres").db
@onready var anny_upgrades_db = preload("res://resources/upgrades/anny_upgrades_db.tres").db

@onready var character_data = {
	Globals.CharacterChoice.NEURO: CharacterData.new("Neuro", neuro_upgrades_db, 45, 75, true),
	Globals.CharacterChoice.VEDAL: CharacterData.new("Vedal", vedal_upgrades_db, 40, 65, false),
	Globals.CharacterChoice.EVIL: CharacterData.new("Evil", evil_upgrades_db, 60, 50, true),
	Globals.CharacterChoice.ANNY: CharacterData.new("Anny", anny_upgrades_db, 45, 60, false)
}

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
