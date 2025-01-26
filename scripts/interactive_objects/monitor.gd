extends Node2D

@onready var press_f_notice = %PressFNotice
@onready var notice = %Notice
@onready var effect_player = $EffectPlayer
@onready var monitor_player: AnimationPlayer = $MonitorPlayer

var tween: Tween
var in_range := false

func _ready() -> void:
	effect_player.play("effect")

func _process(delta: float) -> void:
	if in_range and Input.is_action_just_pressed("use"):
		Globals.request_random_directives.emit()
		queue_free()

func _on_interactible_object_area_entered(area):
	monitor_player.play("activate")

	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(press_f_notice, "modulate:a", 1.0, 1.0)
	in_range = true

func _on_interactible_object_area_exited(area):
	monitor_player.play_backwards("activate")

	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(press_f_notice, "modulate:a", 0.0, 1.0)
	in_range = false
