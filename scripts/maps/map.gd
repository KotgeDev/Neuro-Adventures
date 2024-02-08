extends Node2D
class_name MAP

@export var NTX_BASE_CHANCE := 0.05
@export var NTX_STEP := 0.02

var ntx_chance := 0.05

func _ready() -> void:
	add_to_group("map")
	Globals.map_ready.emit() 
	spawn_enemies()

func spawn_enemies() -> void:
	pass 
