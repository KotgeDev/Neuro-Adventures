extends Area2D
class_name Hurtbox 

signal take_damage(damage)

@export var owned_by: Globals.Owners

func set_damage(damage: float) -> void:	
	take_damage.emit(damage)
