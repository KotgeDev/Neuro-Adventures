extends UpgradeScene

const SPEED := 100
const RUM_DAMAGE := 0.0
const DAMGE_INTERVAl := 1.0

@onready var fire_location = $FireLocation
@onready var collab_partner = get_parent()
@onready var map = get_parent().get_parent()
@onready var fire_timer = $FireTimer

var rum_template = preload("res://scenes/projectiles/rum.tscn")
var hit_sfx: AudioStream = preload("res://assets/sfx/vedal_throw.wav")

var splash_damage: float
var splash_duration: float
var stun_duration: float

func get_data() -> String:
	var data = (
		get_atk_str(splash_damage, "ATK/s") + "\n" +
		get_cd_str(fire_timer.base_cooldown) + "\n" +
		get_time_str("Splash Duration", splash_duration) + "\n" +
		get_time_str("Stun Duration", stun_duration)
	)
	return data

func set_data(
	_splash_damage: float,
	_cooldown: float,
	_splash_duration: float,
	_stun_duration: float
) -> void:
	if _splash_damage: splash_damage = _splash_damage
	if _cooldown: fire_timer.base_cooldown = _cooldown
	if _splash_duration: splash_duration = _splash_duration
	if _stun_duration: stun_duration = _stun_duration

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_data(1.0, 1.5, 0.7, 1.0)
		2:
			set_data(0.0, 0.0, 1.2, 1.5)
		3:
			set_data(0.0, 1.0, 0.0, 0.0)
		4:
			set_data(0.0, 0.0, 2.2, 2.5)
		5:
			set_data(3.0, 0.0, 0.0, 0.0)

func _on_fire_timer_timeout():
	if not collab_partner.character_animation.run_sprite.flip_h:
		fire_location.position = Vector2(10, -7)
	else:
		fire_location.position = Vector2(-10, -7)

	var rum = rum_template.instantiate()
	rum.global_position = fire_location.global_position

	rum.setup(
		SPEED,
		RUM_DAMAGE,
		splash_duration,
		DAMGE_INTERVAl,
		splash_damage,
		stun_duration
	)

	map.add_child(rum)
