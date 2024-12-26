extends Node2D
class_name LampLava

#the amount that the lava will heal to neuro
var heal

#set up the lava 
func setup(damage, heal_amount, scale_mod, duration, wait_time, color):
	#set damage and heal amount
	$ContinuousHitbox.damage = damage
	heal = heal_amount
	
	#scale the hitboxes and sprites
	$ContinuousHitbox.scale *= scale_mod
	$AIHealbox.scale *= scale_mod
	$DamageSprite.scale *= scale_mod
	$WarningSprite.scale *= scale_mod
	
	#set the timers for the hitbox and the healbox
	$ContinuousHitbox/Duration.wait_time = 5
	$ContinuousHitbox/Duration.stop()
	$ContinuousHitbox/HitTimer.wait_time = wait_time
	$AIHealbox/Timer.wait_time = wait_time
	
	#set the damage sprite's initial color
	$DamageSprite.modulate = color

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#you could throw some sfx in here if you wanted. maybe. i don't have them though, so. neuroShrug
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#create a tween between the current color of the lava and a given next color
func start_tween(next: Color, duration) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($DamageSprite, "modulate", next, duration)

#lava lamp explode
func _on_continuous_hitbox_self_destruct() -> void:
	queue_free()

#if the healbox has any overlapping areas (neuro is inside the lava), heal her by the heal amount
func _on_timer_timeout() -> void:
	if $AIHealbox.has_overlapping_areas():
		Globals.heal_ai.emit(heal)

#end the warning and attack
func _on_grace_period_timer_timeout() -> void:
	#activate the hitboxes and healboxes
	$ContinuousHitbox/CollisionShape2D.set_deferred("disabled", false)
	$AIHealbox/CollisionShape2D.set_deferred("disabled", false)
	
	#start the hitbox's duration and healbox's heal timers
	$ContinuousHitbox/Duration.start()
	$AIHealbox/Timer.start()
	
	#remove the warning sprite and make the damage sprite visible
	$DamageSprite.visible = true
	$WarningSprite.visible = false