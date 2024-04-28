extends Node2D

#region NODES
@onready var multi_hitbox = $MultiHitbox
@onready var map = get_tree().get_first_node_in_group("map")
#endregion

#region PROPERTIES
var speed: int 
var damage: float 
var direction: Vector2
#endregion 

func setup(
	p_speed: int,
	p_damage: float, 
	p_direction: Vector2
) -> void: 
	speed = p_speed
	$MultiHitbox.damage = p_damage
	direction = p_direction

func _physics_process(delta: float) -> void:
	position += direction * speed * delta    

func _on_self_destruct_timer_timeout():
	queue_free()
