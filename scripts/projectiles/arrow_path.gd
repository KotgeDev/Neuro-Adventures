extends Node2D

@export var SPEED := 300.0
@onready var warning = $ColorRect
@onready var anim = $AnimationPlayer

var arrow_template = preload("res://scenes/projectiles/arrow.tscn")
var arrow_sfx: AudioStream = preload("res://assets/sfx/arrowswish.wav")
var target: Node
var damage: float
var warning_time: float
var timeout: float

func setup(_target: Node, _damage: float, _warning: float) -> void:
	target = _target
	damage = _damage
	warning_time = _warning

	timeout = 3000.0 / SPEED + warning_time

func _ready() -> void:
	anim.play("pulse")

	await get_tree().create_timer(warning_time, false).timeout

	warning.visible = false

	AudioSystem.play_sfx(arrow_sfx, target.global_position)
	var arrow = arrow_template.instantiate()
	arrow.destroyed.connect(self_destruct)

	add_child(arrow)
	arrow.global_position = global_position
	arrow.setup(global_rotation, SPEED, damage, timeout)

func self_destruct():
	queue_free()
