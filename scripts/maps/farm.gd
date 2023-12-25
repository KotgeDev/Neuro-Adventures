extends Node2D

var slime_template = preload("res://scenes/enemies/slime.tscn")
var goblin_template = preload("res://scenes/enemies/goblin.tscn")
var soldier_template = preload("res://scenes/enemies/soldier.tscn")

func _ready() -> void:
	Globals.map_ready.emit() 
	spawn_enemies() 
	
func spawn_enemies() -> void: 	
	Globals.spawn.emit(slime_template, 500, 0.5) # 250s since game start when over
	await get_tree().create_timer(50, false).timeout # After 100 Slimes have spawned 
	Globals.spawn.emit(goblin_template, 500, 1.0) # 300s since game start when over
	await get_tree().create_timer(100, false).timeout # After 200 Goblims have spawned
	Globals.spawn.emit(slime_template, 500, 1.0) 
	Globals.spawn.emit(soldier_template, 100, 1.0, true) # 350s sec when over 	

func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
