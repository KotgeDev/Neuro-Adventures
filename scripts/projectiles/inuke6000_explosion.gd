extends Node2D

@onready var animation_player = $AnimationPlayer

var nuke_sfx: AudioStream = preload("res://assets/sfx/nukewhistle2.wav")

func setup(
	p_damage: float,
	p_grace_period := 2.0
) -> void:
	$MultiHitbox.damage = p_damage
	$GracePeriodTimer.wait_time = p_grace_period

func _on_grace_period_timer_timeout():
	AudioSystem.play_sfx(nuke_sfx, global_position)
	$NukeExplosion.visible = true 
	animation_player.play("nuke_falling")
	await animation_player.animation_finished
	
	$WarningSprite.visible = false
	$MultiHitbox/CollisionPolygon2D.set_deferred("disabled", false)
	animation_player.play("nuke_exploding")
	await animation_player.animation_finished
	queue_free()
