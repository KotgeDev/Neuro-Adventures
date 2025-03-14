extends Node2D

@onready var press_f_notice = %PressFNotice
@onready var notice = %Notice
@onready var monitor_sprite: Sprite2D = $MonitorSprite

var tween: Tween
var in_range := false
var floating = 1.55334
@onready var current_y_pos = global_position.y

var special := false

func _ready() -> void:
	if special:
		monitor_sprite.texture = preload("res://assets/interactive_objects/directive_special.png")

func _process(delta: float) -> void:
	if in_range and Input.is_action_just_pressed("use"):
		Globals.request_random_directives.emit(special, true)
		queue_free()

	floating += delta*5
	global_position = Vector2(global_position.x, current_y_pos + 4*sin(floating))

func _on_interactible_object_area_entered(area):
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(press_f_notice, "modulate:a", 1.0, 1.0)
	in_range = true

func _on_interactible_object_area_exited(area):
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(press_f_notice, "modulate:a", 0.0, 1.0)
	in_range = false
