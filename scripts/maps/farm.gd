extends Node2D

#region ENEMIES
var slime_template = preload("res://scenes/enemies/enemy_scenes/slime.tscn")
var goblin_template = preload("res://scenes/enemies/enemy_scenes/goblin.tscn")
var kobold_template = preload("res://scenes/enemies/enemy_scenes/kobold.tscn")
var soldier_template = preload("res://scenes/enemies/enemy_scenes/soldier.tscn")
var knight_template = preload("res://scenes/enemies/enemy_scenes/knight.tscn")
#endregion

#region MARCHES
var left_right_flank = preload("res://scenes/enemies/march_scenes/left_right_flank.tscn")
#endregion 

var archer_boss = preload("res://scenes/enemies/boss_scenes/archer_boss.tscn")

func _ready() -> void:
	Globals.map_ready.emit() 
	call_deferred("spawn_enemies")
	
func spawn_enemies() -> void:
	await get_tree().physics_frame
	
	# 30 sec prep time 
	Globals.spawn.emit(slime_template, 50, 0.2)
	await get_tree().create_timer(30).timeout
	
	# First Wave 
	Globals.spawn.emit(goblin_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 100, 1.0)
	Globals.spawn.emit(goblin_template, 100, 1.0)
	await get_tree().create_timer(50).timeout
	add_march(left_right_flank, soldier_template, 60.0)
	await get_tree().create_timer(50).timeout
	# All first wave enemise spawned at this point. 
	await get_tree().create_timer(30).timeout

	# Second Wave 
	print("SECOND WAVE STARTING")
	Globals.spawn.emit(kobold_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 75, 0.5)
	Globals.spawn.emit(goblin_template, 75, 0.7)
	Globals.spawn.emit(kobold_template, 100, 1.0)
	await get_tree().create_timer(50).timeout
	add_march(left_right_flank, kobold_template, 32.0)
	await get_tree().create_timer(50).timeout
	# All first wave enemise spawned at this point.
	await get_tree().create_timer(30).timeout 
	
	# Second Wave 
	print("THIRD WAVE STARTING")
	add_march(left_right_flank, knight_template, 130.0)
	Globals.spawn.emit(soldier_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 50, 2.0)
	Globals.spawn.emit(goblin_template, 50, 2.0)
	Globals.spawn.emit(kobold_template, 50, 2.0)
	Globals.spawn.emit(soldier_template, 100, 1.0)
	await get_tree().create_timer(50).timeout
	add_child(archer_boss.instantiate())
	await get_tree().create_timer(50).timeout
	# All first wave enemise spawned at this point.
	await get_tree().create_timer(30).timeout 

func add_march(march_template: PackedScene, enemy_template: PackedScene, march_duration: float, interval := 1000.0, count := 1) -> void:
	var march1 = march_template.instantiate() 
	march1.setup(enemy_template, march_duration, interval, count)
	add_child(march1)
