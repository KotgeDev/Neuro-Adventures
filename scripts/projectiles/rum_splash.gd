extends Node2D

func setup(duration, hit_wait_time, damage) -> void:
	$ContinuousHitbox/Duration.wait_time = duration
	$ContinuousHitbox/HitTimer.wait_time = hit_wait_time
	$ContinuousHitbox.damage = damage

func _ready() -> void: 
	$AnimationPlayer.play("intro")
	$AnimationPlayer.queue("sizzle")

func _on_continuous_hitbox_self_destruct():
	queue_free()
