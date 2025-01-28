extends Node2D

@onready var pipe_player: AnimationPlayer = $PipePlayer

func setup(_damage: float) -> void:
	$MultiHitbox.damage = _damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pipe_player.play("pipe")
