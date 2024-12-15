extends Area2D
class_name Hurtbox 

## Signal sent when the hitbox has received damage 
signal take_damage(damage)

@export var owned_by: Globals.Owners

func receive_damage(damage: float) -> void:	
	take_damage.emit(damage)
