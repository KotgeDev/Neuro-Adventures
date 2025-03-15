extends MAP

#region ENEMIES
var slime_template = preload("res://scenes/enemies/basic_enemies/slime.tscn")
var goblin_template = preload("res://scenes/enemies/basic_enemies/goblin.tscn")
var kobold_template = preload("res://scenes/enemies/basic_enemies/kobold.tscn")
var soldier_template = preload("res://scenes/enemies/basic_enemies/soldier.tscn")
var knight_template = preload("res://scenes/enemies/basic_enemies/knight.tscn")
var femboy_elf = preload("res://scenes/enemies/elite_enemies/femboy_elf.tscn")
#endregion

func spawn_enemies() -> void:
	await get_tree().process_frame

	await wave0()
	spawn_monitor()
	await wave1()
	spawn_monitor()
	await wave2()
	spawn_monitor()
	await wave3()
	spawn_monitor()
	await wave4()
	spawn_monitor()
	await wave5()
	spawn_monitor(true)
	await wave6()

	# In case the player takes too long to defeat the boss
	await wave5()

func spawn_enemies_endless() -> void:
	await get_tree().process_frame

	await wave0()
	spawn_monitor()
	await wave1()
	spawn_monitor()
	await wave2()
	spawn_monitor()
	await wave3()
	spawn_monitor()
	await wave4()
	spawn_monitor()
	await wave5()
	spawn_monitor(true)
	await wave6()

	var i = 0
	while true:
		i += 1
		endless_stat_scale(i)
		await wave5()
		spawn_monitor()

		i += 1
		endless_stat_scale(i)
		if i % 2 == 0:
			await wave6()
			spawn_monitor()
		else:
			await wave5()
			spawn_monitor()

func wave0() -> void:
	print_rich("[color=pink]Wave 0 Start[/color]")
	Globals.spawn.emit(slime_template, 100, 0.4)
	await get_tree().create_timer(30, false).timeout
	print_rich("[color=green]Wave 0 End[/color]")

func wave1() -> void:
	print_rich("[color=pink]Wave 1 Start[/color]")
	Globals.spawn.emit(goblin_template, 175, 0.53)
	await get_tree().create_timer(35, false).timeout
	add_march(horizontal_march, kobold_template)
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Wave 1 End[/color]")

func wave2() -> void:
	print_rich("[color=pink]Wave 2 Start[/color]")
	Globals.spawn.emit(kobold_template, 225, 0.53)
	await get_tree().create_timer(50, false).timeout
	add_march(horizontal_march, soldier_template)
	await get_tree().create_timer(50, false).timeout
	print_rich("[color=green]Wave 2 End[/color]")

func wave3() -> void:
	print_rich("[color=pink]Wave 2 Start[/color]")
	Globals.spawn.emit(soldier_template, 225, 0.53)
	await get_tree().create_timer(50, false).timeout
	add_march(vertical_march, knight_template)
	await get_tree().create_timer(50, false).timeout
	print_rich("[color=green]Wave 2 End[/color]")

func wave4() -> void:
	print_rich("[color=pink]Wave 2 Start[/color]")
	Globals.spawn.emit(knight_template, 225, 0.53)
	await get_tree().create_timer(50, false).timeout
	add_march(horizontal_march, knight_template)
	await get_tree().create_timer(50, false).timeout
	print_rich("[color=green]Wave 2 End[/color]")

func wave5() -> void:
	print_rich("[color=pink]Wave 5 Start[/color]")
	Globals.spawn.emit(goblin_template, 125, 0.37, 2)
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(kobold_template, 125, 0.37, 2)
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(soldier_template, 125, 0.37)
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(knight_template, 250, 0.5)
	await get_tree().create_timer(40, false).timeout
	add_march(horizontal_march, knight_template)
	await get_tree().create_timer(40, false).timeout
	print_rich("[color=green]Wave 5 End[/color]")

func wave6() -> void:
	print_rich("[color=pink]Wave 6 Start[/color]")
	Globals.spawn.emit(goblin_template, 150, 0.31, 2)
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(kobold_template, 150, 0.31, 2)
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(soldier_template, 150, 0.31)
	await get_tree().create_timer(35, false).timeout
	Globals.spawn.emit(knight_template, 300, 0.36)
	await get_tree().create_timer(40, false).timeout
	print_rich("[color=crimson]Boss Spawned![/color]")
	add_child(femboy_elf.instantiate())
	await get_tree().create_timer(40, false).timeout
	print_rich("[color=green]Wave 6 End[/color]")
