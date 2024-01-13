extends Node2D
class_name Enemy

func _ready() -> void:
	add_to_group("enemy")
	ready()

## Override to use 
func ready() -> void:
	pass 
