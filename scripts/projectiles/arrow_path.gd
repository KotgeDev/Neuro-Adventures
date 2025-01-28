extends Node2D

@export var SPEED := 300.0
@export var DAMAGE := 3.0
@export var WARNING_TIME := 1.5

@onready var timeout = 3000.0 / SPEED + WARNING_TIME
@onready var ai: AI = get_tree().get_first_node_in_group("ai")
@onready var warning = $ColorRect
@onready var anim = $AnimationPlayer

var arrow_template = preload("res://scenes/projectiles/arrow.tscn")
var arrow_sfx: AudioStream = preload("res://assets/sfx/arrowswish.wav")
var sfx := false

func _ready() -> void:
	anim.play("pulse")

	await get_tree().create_timer(WARNING_TIME, false).timeout

	warning.visible = false

	if sfx:
		AudioSystem.play_sfx(arrow_sfx, ai.global_position)
	var arrow = arrow_template.instantiate()
	arrow.destroyed.connect(self_destruct)
	add_child(arrow)
	arrow.global_position = self.global_position
	arrow.setup(global_rotation, SPEED, DAMAGE, timeout)

func self_destruct():
	queue_free()
