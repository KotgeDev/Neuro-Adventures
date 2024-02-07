extends UpgradeScene

@export var LV1_FIRE_RATE := 3.0
@export var LV3_FIRE_RATE := 1.5 
@export var LV1_DAMAGE := 1.0 
@export var LV4_DAMAGE := 2.0 
@export var LV1_HIT_COUNT := 1
@export var LV2_HIT_COUNT := 3 

@onready var fire_timer = $FireTimer
@onready var enemy_search_area = $EnemySearchArea
@onready var ai = get_parent()
@onready var map = get_tree().get_first_node_in_group("map")
@onready var right_marker = $RightMarker
@onready var left_marker = $LeftMarker

var feather_path_template = preload("res://scenes/projectiles/feather_path.tscn")
var damage: float 
var hit_count: int 
var feather_count: int 

func _ready() -> void:
	sync_level() 

func sync_level() -> void:
	match upgrade.lvl: 
		1:
			fire_timer.wait_time = LV1_FIRE_RATE
			damage = LV1_DAMAGE
			hit_count = LV1_HIT_COUNT 
			feather_count = 1
		2:
			hit_count = LV2_HIT_COUNT
		3:
			fire_timer.wait_time = LV3_FIRE_RATE
		4:
			damage = LV4_DAMAGE    
		5:
			feather_count = 2 

func _on_fire_timer_timeout():
	var enemies := []

	for enemy in enemy_search_area.get_overlapping_areas():
		enemies.append(enemy)
	enemies.shuffle()
	
	for i in range(feather_count):
		if enemies.size() >= i + 1: 
			var feather_path = feather_path_template.instantiate() 
			if ai.global_position.x > enemies[i].global_position.x:	
				feather_path.global_position = left_marker.global_position
			else:
				feather_path.global_position = right_marker.global_position
			feather_path.look_at(enemies[i].global_position)
			feather_path.setup(damage, hit_count)
			map.call_deferred("add_child", feather_path) 
