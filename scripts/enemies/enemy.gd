extends Node2D
class_name Enemy

@export var BASE_MAX_HEALTH := 1.0
@export var BASE_MAX_SPEED := 1.0
@export var BASE_DAMAGE := 1.0
@export var ATTACK_INTERVAL := 1.0
@export var EXP := 1.0

func _ready() -> void:
	add_to_group("enemy")
	set_mode()
	ready()

## Override to use
## _ready alternative
func ready() -> void:
	pass

## Override to use
## For setting stats for different modes
func set_mode() -> void:
	pass
