extends UpgradeScene

@export var lv1_chance = 0.01 
@export var lv2_chance = 0.02
@export var lv3_chance = 0.03
@export var lv4_chance = 0.05

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
	
