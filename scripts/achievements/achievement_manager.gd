extends Node

signal add_achievement(index: int) 

var achievement_path = "user://achievements.save"

var achievement_objects = {
	0: Achievement.new(
		"First Victory!",
		"Win your first game",
		preload("res://assets/achievements/first_victory.png")
	),
	1: Achievement.new(
		"Integration",
		"Defeat the Elf archer boss of the map The Farm ",
		preload("res://assets/achievements/integrated_him.png")
	),
	2: Achievement.new(
		"DMg Allegations",
		"Win a game without the collab partner taking any damage",
		preload("res://assets/achievements/dmg_allegations.png")
	),
	3: Achievement.new(
		"Swarm Commander",
		"Win a game while having 10 gymbag drones and max lvl \"Swarm Upgrades\"",
		preload("res://assets/achievements/swarm_commander.png")
	),
	4: Achievement.new(
		"Neverending Subathon",
		"Win a game while having the upgrade, \"Raise the Timer\". Lvl is not important.",
		preload("res://assets/achievements/neverending_subathon.png")
	),
	5: Achievement.new(
		"True Love",
		"Win a game while having maxed both the upgrades \"Say it Back!\" and \"Dual Strike\"",
		preload("res://assets/achievements/true_love.png")
	)
}

var achievement_status = {
	0: false,
	1: false, 
	2: false,
	3: false,
	4: false,
	5: false 
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_achievement.connect(_on_add_achievement)
	load_data() 

func _on_add_achievement(index: int) -> void:
	achievement_status[index] = true
	save_data()  

func load_data() -> void:
	if FileAccess.file_exists(achievement_path):
		var file = FileAccess.open(achievement_path, FileAccess.READ)
		achievement_status = file.get_var()
		# Check and fill in any missing achievement indexes
		for index in achievement_objects.keys():
			if not achievement_status.has(index):
				achievement_status[index] = false 
	else:
		save_data()

func save_data() -> void:
	var file = FileAccess.open(achievement_path, FileAccess.WRITE)
	file.store_var(achievement_status)
