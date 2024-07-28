extends Control

var cursor = preload("res://assets/ui/cursor.png")

@export var upgrades_menu: Control

@onready var options_menu = $OptionsMenu
@onready var paused_menu = $PausedMenu

var start_time_msec := 0.0
var pause_start_time_msec := 0.0
var total_paused_time_msec := 0.0 
var game_over := false 

func _ready() -> void:
	start_time_msec = Time.get_ticks_msec()
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(32, 32))

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if options_menu.visible or game_over:
			return 
		
		if upgrades_menu.visible: 
			if visible:
				visible = false 
			else:
				visible = true 
			return  
		
		if visible: 
			unpause_game(true) 
		else:
			pause_game(true)   

## Call to pause the game 
func pause_game(show_menu := false):
	Input.set_custom_mouse_cursor(null)
	get_tree().paused = true
	pause_start_time_msec = Time.get_ticks_msec()
	
	if show_menu:
		visible = true 

## Call to unpause the game 
func unpause_game(hide_menu := false):
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(32, 32))
	get_tree().paused = false
	total_paused_time_msec += Time.get_ticks_msec() - pause_start_time_msec
	
	if hide_menu:
		visible = false

## Call to get elapsed time excluding time that was spent paused 
func get_elapsed_time() -> String: 
	var survival_sec: int = roundi((Time.get_ticks_msec() - start_time_msec - total_paused_time_msec) / 1000.0) 
	var min: int = int(survival_sec / 60)
	var sec: int = roundi(survival_sec % 60)
	return "%02d:%02d" % [min, sec] 

func _on_continue_button_pressed():
	unpause_game(true)

func _on_options_button_pressed():
	options_menu.visible = true 
	paused_menu.visible = false 
	
func _on_options_menu_close_panel():
	options_menu.visible = false
	paused_menu.visible = true 

func _on_quit_button_pressed():
	AudioSystem.end_music()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
