extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("strike")
	await get_tree().create_timer(0.4, false).timeout
	queue_free()

func setup(damage: float, flip: bool) -> void:
	if flip: scale = Vector2(1, -1)
	$MultiHitbox.damage = damage
