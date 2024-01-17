extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D

func _ready() -> void:
	Globals.spawn.connect(_on_spawn)

func _on_spawn(scene_template, count: int, time_interval: float, last_batch := false) -> void:
	for i in range(count):
		path_follow_2d.progress_ratio = randf_range(0.0, 1.0)
		await get_tree().create_timer(time_interval, false).timeout 
		var enemy = scene_template.instantiate()
		enemy.global_position = path_follow_2d.position 
		add_child(enemy)
		
		if last_batch and i == count - 1:
			enemy.last_enemy = true 
