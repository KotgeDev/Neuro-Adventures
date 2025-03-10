extends Node2D

signal destroyed

var speed: float

func set_up(p_speed: float, p_damage: float, timeout: float, pierce: int) -> void:
	speed = p_speed
	$MultiHitbox.damage = p_damage
	$MultiHitbox.count = pierce
	$SelfDestructTimer.wait_time = timeout

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_self_destruct_timer_timeout():
	destroyed.emit()
	queue_free()

func _on_multi_hitbox_self_destruct():
	destroyed.emit()
	queue_free()
