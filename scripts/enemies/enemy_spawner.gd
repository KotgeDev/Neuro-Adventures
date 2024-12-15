extends Node2D

const RADIUS = 300

@onready var HALF_WIDTH = get_viewport().size.x 
@onready var HALF_HEIGHT = get_viewport().size.y 

func _ready() -> void:
	Globals.spawn.connect(_on_spawn)

func _on_spawn(scene_template, count: int, time_interval: float, last_batch := false) -> void:
	for i in range(count):
		await get_tree().create_timer(time_interval, false).timeout 
		var enemy = scene_template.instantiate()
		enemy.global_position = get_random_pos() 
		add_child(enemy)
		
		if last_batch and i == count - 1:
			enemy.last_enemy = true 

func get_random_pos() -> Vector2: 
	var angle = randf() * PI * 2 
	var ai_pos = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME).global_position
	var offset = Vector2(cos(angle), sin(angle)) * RADIUS 
	return offset + ai_pos
