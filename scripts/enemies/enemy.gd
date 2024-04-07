extends Node2D
class_name Enemy

@export var BASE_MAX_SPEED: float
@onready var max_speed := BASE_MAX_SPEED

func _ready() -> void:
	add_to_group("enemy")
	ready()

## Override to use 
func ready() -> void:
	pass 
