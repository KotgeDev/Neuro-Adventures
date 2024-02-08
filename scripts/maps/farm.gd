extends MAP

#region ENEMIES
var slime_template = preload("res://scenes/enemies/enemy_scenes/slime.tscn")
var goblin_template = preload("res://scenes/enemies/enemy_scenes/goblin.tscn")
var kobold_template = preload("res://scenes/enemies/enemy_scenes/kobold.tscn")
var soldier_template = preload("res://scenes/enemies/enemy_scenes/soldier.tscn")
var knight_template = preload("res://scenes/enemies/enemy_scenes/knight.tscn")
#endregion

#region MARCHES
var left_right_flank = preload("res://scenes/enemies/march_scenes/left_right_flank.tscn")
var top_down_flank = preload("res://scenes/enemies/march_scenes/top_down_flank.tscn")
#endregion 

#region BOSS
var archer_boss = preload("res://scenes/enemies/boss_scenes/archer_boss.tscn")
#endregion 

func spawn_enemies() -> void:
	await get_tree().process_frame
	
	Globals.spawn.emit(kobold_template, 200, 0.1)
	return
	
	# 30 sec prep time 
	Globals.spawn.emit(slime_template, 50, 0.2)
	await get_tree().create_timer(30, false).timeout
	
	# First Wave 
	Globals.spawn.emit(goblin_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 100, 1.0)
	Globals.spawn.emit(goblin_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	add_march(left_right_flank, kobold_template, 32.0)
	await get_tree().create_timer(50, false).timeout
	# All first wave enemise spawned at this point. 
	await get_tree().create_timer(30, false).timeout

	# Second Wave 
	print("SECOND WAVE STARTING")
	Globals.spawn.emit(kobold_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 75, 0.5)
	Globals.spawn.emit(goblin_template, 75, 0.7)
	Globals.spawn.emit(kobold_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	add_march(left_right_flank, soldier_template, 43.0)
	await get_tree().create_timer(50, false).timeout
	# All first wave enemise spawned at this point.
	await get_tree().create_timer(30, false).timeout 
	
	# Third Wave 
	print("THIRD WAVE STARTING")
	Globals.spawn.emit(soldier_template, 20, 0.2)
	Globals.spawn.emit(goblin_template, 75, 1.0)
	Globals.spawn.emit(kobold_template, 75, 1.0)
	Globals.spawn.emit(soldier_template, 100, 1.0)
	await get_tree().create_timer(100, false).timeout
	# All first wave enemise spawned at this point.
	await get_tree().create_timer(30, false).timeout 
	
	# Final Wave 
	print("FINAL WAVE STARTING")
	Globals.spawn.emit(knight_template, 20, 0.2)
	Globals.spawn.emit(kobold_template, 75, 1.0)
	Globals.spawn.emit(soldier_template, 75, 1.0)
	Globals.spawn.emit(knight_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	Globals.spawn.emit(knight_template, 1000, 3.0)
	add_child(archer_boss.instantiate())
	await get_tree().create_timer(50, false).timeout

func add_march(march_template: PackedScene, enemy_template: PackedScene, march_duration: float, interval := 1000.0, count := 1) -> void:
	var march1 = march_template.instantiate() 
	march1.setup(enemy_template, march_duration, interval, count)
	add_child(march1)
