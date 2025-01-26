extends MAP

#region ENEMIES
var slime_template = preload("res://scenes/enemies/simple_enemies/slime.tscn")
var goblin_template = preload("res://scenes/enemies/simple_enemies/goblin.tscn")
var kobold_template = preload("res://scenes/enemies/simple_enemies/kobold.tscn")
var soldier_template = preload("res://scenes/enemies/simple_enemies/soldier.tscn")
var knight_template = preload("res://scenes/enemies/simple_enemies/knight.tscn")
var femboy_elf = preload("res://scenes/enemies/bosses/femboy_elf.tscn")
#endregion

func spawn_enemies() -> void:
	var nice = 1.0

	await get_tree().process_frame

	spawn_monitor()
	await wave1() #10
	spawn_monitor()
	await wave2() #110
	spawn_monitor()
	await wave3() #210
	spawn_monitor()
	await wave4() #310
	spawn_monitor()
	await wave5() #410
	spawn_monitor()
	await wave6() #510
	spawn_monitor()
	await boss_wave() #610 = 10.1 minutes

func spawn_enemies_endless() -> void:
	await get_tree().process_frame
#
	## 20 sec prep time
	#Globals.spawn.emit(slime_template, 50, 0.2)
	#await get_tree().create_timer(20, false).timeout
#
	#await first_wave()
	#await second_wave()
#
	#scaling_difficulty += scale_factor
	#await third_wave()
#
	#while true:
		#scaling_difficulty += scale_factor
		#await loop_wave()
#
		#scaling_difficulty += scale_factor
		#await loop_wave(true)

func wave1() -> void:
	add_march(horizontal_march, kobold_template)
	print_rich("[color=pink]Wave 1 Start[/color]")
	Globals.spawn.emit(slime_template, 30, 0.1)
	await get_tree().create_timer(10, false).timeout
	print_rich("[color=green]Wave 1 End[/color]")

func wave2() -> void:
	print_rich("[color=pink]Wave 2 Start[/color]")
	Globals.spawn.emit(slime_template, 100, 0.7)
	Globals.spawn.emit(goblin_template, 50, 1.4)
	await get_tree().create_timer(35, false).timeout
	add_march(horizontal_march, kobold_template)
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Wave 2 End[/color]")

func wave3() -> void:
	print_rich("[color=pink]Wave 3 Start[/color]")
	Globals.spawn.emit(goblin_template, 50, 1.4)
	Globals.spawn.emit(kobold_template, 100, 0.7)
	await get_tree().create_timer(35, false).timeout
	add_march(horizontal_march, soldier_template)
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Wave 3 End[/color]")

func wave4() -> void:
	print_rich("[color=pink]Wave 4 Start[/color]")
	Globals.spawn.emit(kobold_template, 100, 0.7)
	Globals.spawn.emit(soldier_template, 100, 0.7)
	await get_tree().create_timer(35, false).timeout
	add_march(horizontal_march, goblin_template)
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Wave 4 End[/color]")

func wave5() -> void:
	print_rich("[color=pink]Wave 5 Start[/color]")
	Globals.spawn.emit(soldier_template, 100, 0.7)
	Globals.spawn.emit(goblin_template, 150, 0.4)
	await get_tree().create_timer(35, false).timeout
	add_march(horizontal_march, soldier_template)
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Wave 5 End[/color]")

func wave6() -> void:
	print_rich("[color=pink]Wave 6 Start[/color]")
	Globals.spawn.emit(kobold_template, 75, 0.9)
	Globals.spawn.emit(soldier_template, 75, 0.9)
	Globals.spawn.emit(goblin_template, 75, 0.9)
	Globals.spawn.emit(knight_template, 50, 1.0)
	await get_tree().create_timer(35, false).timeout
	add_march(vertical_march, soldier_template)
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Wave 6 End[/color]")

func boss_wave() -> void:
	print_rich("[color=crimson]Boss Wave Start[/color]")
	Globals.spawn.emit(kobold_template, 75, 0.9)
	Globals.spawn.emit(soldier_template, 75, 0.9)
	Globals.spawn.emit(goblin_template, 75, 0.9)
	Globals.spawn.emit(knight_template, 100, 1.0)
	await get_tree().create_timer(35, false).timeout
	add_child(femboy_elf.instantiate())
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(knight_template, 1000, 5.0)

#func first_wave() -> void:
	#print_rich("[color=pink]First Wave Starting[/color]")
	#Globals.spawn.emit(goblin_template, 20, 0.2)
	#Globals.spawn.emit(slime_template, 100, 1.0)
	#Globals.spawn.emit(goblin_template, 100, 1.0)
	#await get_tree().create_timer(50, false).timeout
	#add_march(horizontal_march, kobold_template, 32.0)
	#await get_tree().create_timer(50, false).timeout
	## All first wave enemise spawned at this point.
	#await get_tree().create_timer(30, false).timeout
	#print_rich("[color=green]First Wave Complete[/color]")
#
#func second_wave() -> void:
	#print_rich("[color=pink]Second Wave Starting[/color]")
	#Globals.spawn.emit(kobold_template, 20, 0.2)
	#Globals.spawn.emit(slime_template, 75, 0.5)
	#Globals.spawn.emit(goblin_template, 75, 0.7)
	#Globals.spawn.emit(kobold_template, 100, 1.0)
	#await get_tree().create_timer(50, false).timeout
	#add_march(horizontal_march, soldier_template, 43.0)
	#await get_tree().create_timer(50, false).timeout
	## All first wave enemise spawned at this point.
	#await get_tree().create_timer(30, false).timeout
	#print_rich("[color=green]Second Wave Complete[/color]")
#
#func third_wave() -> void:
	#print_rich("[color=pink]Third Wave Starting[/color]")
	#Globals.spawn.emit(soldier_template, 20, 0.2)
	#Globals.spawn.emit(goblin_template, 75, 1.0)
	#Globals.spawn.emit(kobold_template, 75, 1.0)
	#Globals.spawn.emit(soldier_template, 100, 1.0)
	#await get_tree().create_timer(50, false).timeout
	#add_march(horizontal_march, knight_template, 42.0)
	#await get_tree().create_timer(50, false).timeout
	## All first wave enemise spawned at this point.
	#await get_tree().create_timer(30, false).timeout
	#print_rich("[color=green]Third Wave Complete[/color]")
#
#func final_wave() -> void:
	#print_rich("[color=pink]Final Wave Starting[/color]")
	#Globals.spawn.emit(knight_template, 20, 0.2)
	#Globals.spawn.emit(kobold_template, 75, 1.0)
	#Globals.spawn.emit(soldier_template, 75, 1.0)
	#Globals.spawn.emit(knight_template, 100, 1.0)
	#await get_tree().create_timer(50, false).timeout
	#Globals.spawn.emit(knight_template, 1000, 3.0)
	#add_child(femboy_elf.instantiate())
	#await get_tree().create_timer(50, false).timeout
	#print_rich("[color=green]Final Wave Complete[/color]")
#
#func loop_wave(spawn_bos := false) -> void:
	#print_rich("[color=pink]Loop Wave Starting[/color]")
	#Globals.spawn.emit(knight_template, 20, 0.2)
	#Globals.spawn.emit(kobold_template, 75, 1.0)
	#Globals.spawn.emit(soldier_template, 75, 1.0)
	#Globals.spawn.emit(knight_template, 100, 1.0)
	#await get_tree().create_timer(50, false).timeout
	#if spawn_bos:
		#add_child(femboy_elf.instantiate())
	#await get_tree().create_timer(50, false).timeout
	#print_rich("[color=green]Loop Wave Complete[/color]")
