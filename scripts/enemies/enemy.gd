extends Node2D
class_name Enemy

func _ready() -> void:
	add_to_group("enemy")
	set_stats() 
	ready()

## Override to use 
## _ready alternative 
func ready() -> void:
	pass 

## Override to use 
## For setting stats for different modes 
func set_stats() -> void:
	pass 
