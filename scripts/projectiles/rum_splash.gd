extends Node2D

@onready var sfx: AudioStream = preload("res://assets/sfx/mayberumsplash.wav")

var stun_time

func setup(duration, hit_wait_time, damage, p_stun) -> void:
	$ContinuousHitbox/Duration.wait_time = duration
	$ContinuousHitbox/HitTimer.wait_time = hit_wait_time
	$ContinuousHitbox.damage = damage
	stun_time = p_stun

func _ready() -> void:
	$AnimationPlayer.play("intro")
	$AnimationPlayer.queue("sizzle")

	AudioSystem.play_sfx(sfx, global_position, 0.3)

func _on_continuous_hitbox_self_destruct():
	queue_free()

func _on_stun_zone_area_entered(area):
	if stun_time > 0 and area.get_parent() is SimpleEnemy:
		var enemy = area.get_parent() as SimpleEnemy
		enemy.stun(stun_time)
