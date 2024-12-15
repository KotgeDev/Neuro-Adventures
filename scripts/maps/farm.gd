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

	# 30 sec prep time 
	Globals.spawn.emit(goblin_template, 500, 0.05)
	await get_tree().create_timer(30, false).timeout
	
	return
	await first_wave()
	await second_wave()
	await third_wave()
	await final_wave()

func spawn_enemies_endless() -> void:	
	await get_tree().process_frame

	# 20 sec prep time 
	Globals.spawn.emit(slime_template, 50, 0.2)
	await get_tree().create_timer(20, false).timeout
	
	await first_wave()
	await second_wave() 

	scaling_difficulty += scale_factor
	await third_wave() 

	while true: 
		scaling_difficulty += scale_factor 
		await loop_wave()

		scaling_difficulty += scale_factor
		await loop_wave(true)  

func first_wave() -> void: 
	print_rich("[color=pink]First Wave Starting[/color]")
	Globals.spawn.emit(goblin_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 100, 1.0)
	Globals.spawn.emit(goblin_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	add_march(left_right_flank, kobold_template, 32.0)
	await get_tree().create_timer(50, false).timeout
	# All first wave enemise spawned at this point. 
	await get_tree().create_timer(30, false).timeout
	print_rich("[color=green]First Wave Complete[/color]")

func second_wave() -> void: 
	print_rich("[color=pink]Second Wave Starting[/color]")
	Globals.spawn.emit(kobold_template, 20, 0.2)
	Globals.spawn.emit(slime_template, 75, 0.5)
	Globals.spawn.emit(goblin_template, 75, 0.7)
	Globals.spawn.emit(kobold_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	add_march(left_right_flank, soldier_template, 43.0)
	await get_tree().create_timer(50, false).timeout
	# All first wave enemise spawned at this point.
	await get_tree().create_timer(30, false).timeout 
	print_rich("[color=green]Second Wave Complete[/color]")
	
func third_wave() -> void: 
	print_rich("[color=pink]Third Wave Starting[/color]")
	Globals.spawn.emit(soldier_template, 20, 0.2)
	Globals.spawn.emit(goblin_template, 75, 1.0)
	Globals.spawn.emit(kobold_template, 75, 1.0)
	Globals.spawn.emit(soldier_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	add_march(left_right_flank, knight_template, 42.0)
	await get_tree().create_timer(50, false).timeout
	# All first wave enemise spawned at this point.
	await get_tree().create_timer(30, false).timeout
	print_rich("[color=green]Third Wave Complete[/color]") 
	
func final_wave() -> void:  
	print_rich("[color=pink]Final Wave Starting[/color]")
	Globals.spawn.emit(knight_template, 20, 0.2)
	Globals.spawn.emit(kobold_template, 75, 1.0)
	Globals.spawn.emit(soldier_template, 75, 1.0)
	Globals.spawn.emit(knight_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	Globals.spawn.emit(knight_template, 1000, 3.0)
	add_child(archer_boss.instantiate())
	await get_tree().create_timer(50, false).timeout
	print_rich("[color=green]Final Wave Complete[/color]")

func loop_wave(spawn_bos := false) -> void: 
	print_rich("[color=pink]Loop Wave Starting[/color]")
	Globals.spawn.emit(knight_template, 20, 0.2)
	Globals.spawn.emit(kobold_template, 75, 1.0)
	Globals.spawn.emit(soldier_template, 75, 1.0)
	Globals.spawn.emit(knight_template, 100, 1.0)
	await get_tree().create_timer(50, false).timeout
	if spawn_bos:
		add_child(archer_boss.instantiate())
	await get_tree().create_timer(50, false).timeout
	print_rich("[color=green]Loop Wave Complete[/color]")

func add_march(march_template: PackedScene, enemy_template: PackedScene, march_duration: float, interval := 1000.0, count := 1) -> void:
	var march1 = march_template.instantiate() 
	march1.setup(enemy_template, march_duration, interval, count)
	add_child(march1)
