extends UpgradeScene

@export var lv1_chance = 1 
@export var lv2_chance = 2
@export var lv3_chance = 5
@export var lv4_chance = 10

@onready var ai: AI = get_parent() 

func _ready() -> void:
	sync_level()

func sync_level() -> void:
	match upgrade.lvl: 
		1:
			ai.cookie_drop_chance = lv1_chance
		2:
			ai.cookie_drop_chance = lv2_chance
		3:
			ai.cookie_drop_chance = lv3_chance	
		4:
			ai.cookie_drop_chance = lv4_chance
	
