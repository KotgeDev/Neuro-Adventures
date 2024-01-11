extends Node2D

#region ENEMIES
var slime_template = preload("res://scenes/enemies/enemy_scenes/slime.tscn")
var goblin_template = preload("res://scenes/enemies/enemy_scenes/goblin.tscn")
var kobold_template = preload("res://scenes/enemies/enemy_scenes/kobold.tscn")
var soldier_template = preload("res://scenes/enemies/enemy_scenes/soldier.tscn")
var knight_template = preload("res://scenes/enemies/enemy_scenes/knight.tscn")
#endregion

#region MARCHES
var left_continuous_template = preload("res://scenes/enemies/march_scenes/left_continuous_march.tscn")
var left_right_flank = preload("res://scenes/enemies/march_scenes/left_right_flank.tscn")
#endregion 

func _ready() -> void:
	Globals.map_ready.emit() 
	spawn_enemies() 
	
func spawn_enemies() -> void: 	
	add_march(left_right_flank, knight_template, 245.0, 500.0)
	Globals.spawn.emit(slime_template, 500, 0.5) # 250s since game start when over
	await get_tree().create_timer(50, false).timeout # After 100 Slimes have spawned 
	Globals.spawn.emit(goblin_template, 500, 1.0) # 300s since game start when over
	await get_tree().create_timer(100, false).timeout # After 200 Goblims have spawned
	Globals.spawn.emit(slime_template, 500, 1.0) 
	Globals.spawn.emit(soldier_template, 100, 1.0, true) # 350s sec when over 	

func add_march(march_template: PackedScene, enemy_template: PackedScene, march_duration: float, interval: float) -> void:
	var march1 = march_template.instantiate() 
	march1.setup(enemy_template, march_duration, interval)
	add_child(march1)
