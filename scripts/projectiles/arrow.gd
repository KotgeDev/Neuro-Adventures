extends Node2D

signal destroyed

var speed: float

func setup(p_rotation: float, p_speed: float, p_damage: float, timeout: float) -> void:
	global_rotation = p_rotation
	speed = p_speed
	$MultiHitbox.damage = p_damage
	$SelfDestructTimer.wait_time = timeout

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_self_destruct_timer_timeout():
	destroyed.emit()
	queue_free()

func _on_multi_hitbox_self_destruct():
	destroyed.emit()
	queue_free()
