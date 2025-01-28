extends Node2D

@onready var press_f_notice = %PressFNotice
@onready var notice = %Notice
@onready var fan_spin_player = $FanSpinPlayer
@onready var effect_player = $EffectPlayer
@onready var upgrade_manager

var tween: Tween
var in_range := false

func _ready() -> void:
	fan_spin_player.play("fan_spin")
	effect_player.play("effect")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_range and Input.is_action_just_pressed("use"):
		Globals.request_all_existing_non_max_upgrades.emit()
		queue_free()

func _on_interactible_object_area_entered(area):
	notice.text = " Press F to Use "

	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(press_f_notice, "modulate:a", 1.0, 1.0)
	in_range = true

func _on_interactible_object_area_exited(area):
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(press_f_notice, "modulate:a", 0.0, 1.0)
	in_range = false
