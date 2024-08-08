extends Node2D
class_name March 

var enemy_template: PackedScene 
var march_duration: float
var count: int
var interval: float 

@onready var markers = $Markers

func setup(p_enemy_template: PackedScene, p_march_duration: float, p_interval: float, p_count: int) -> void:
	enemy_template = p_enemy_template
	march_duration = p_march_duration
	interval = p_interval
	count = p_count

func _ready() -> void: 
	$MarchDuration.wait_time = march_duration
	$MarchDuration.start()
	
	setup_markers()
	
	add_wave()

## Override to use 
func setup_markers() -> void:
	pass 

func add_wave() -> void:
	for marker in markers.get_children():
		var enemy = enemy_template.instantiate() as SimpleEnemy 
		enemy.global_position = marker.global_position
		
		enemy.march = true  
		enemy.march_direction = marker.transform.x
		enemy.march_duration = march_duration 
		
		add_child(enemy)
		enemy.navigation_agent.avoidance_enabled = false 

func _on_march_duration_timeout():
	queue_free()
