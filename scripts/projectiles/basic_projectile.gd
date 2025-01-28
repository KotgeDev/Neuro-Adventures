extends Node2D
## Basic projectile script
## Requires a Multihitbox and SelfDestructTimer
## Make sure to connect the required signals
class_name BasicProjectile

signal destroyed

var speed: float

func setup(
	_speed: float,
	_damage: float,
	_count: int,
	timeout: float,
) -> void:
	speed = _speed
	$MultiHitbox.damage = _damage
	$MultiHitbox.count = _count
	$SelfDestructTimer.wait_time = timeout

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_self_destruct_timer_timeout():
	destroyed.emit()
	queue_free()

func _on_multi_hitbox_self_destruct():
	destroyed.emit()
	queue_free()
