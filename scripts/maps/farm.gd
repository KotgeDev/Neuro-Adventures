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

	var i := 0
	while true:
		endless_stat_scale(i)
		await wave6()
		endless_stat_scale(i)
		await final_loop_wave(i % 2 == 0)
		spawn_monitor()
		i += 1

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

func final_loop_wave(spawn_boss := false) -> void:
	print_rich("[color=crimson]Boss Wave Start[/color]")
	Globals.spawn.emit(kobold_template, 75, 0.9)
	Globals.spawn.emit(soldier_template, 75, 0.9)
	Globals.spawn.emit(goblin_template, 75, 0.9)
	Globals.spawn.emit(knight_template, 100, 1.0)
	await get_tree().create_timer(35, false).timeout
	if spawn_boss:
		add_child(femboy_elf.instantiate())
	await get_tree().create_timer(35, false).timeout
	print_rich("[color=green]Loop Wave End[/color]")
