extends UpgradeScene

var fireball_template = preload("res://scenes/projectiles/fireball.tscn")

@onready var ai: AI = get_tree().get_first_node_in_group("ai")
@onready var map: MAP = get_tree().get_first_node_in_group("map")
@onready var fire_timer = $FireTimer

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/laser_fire.wav")
#endregion

var speed = 100
var damage: float
var pierce: int
var projectile_count: int
var randomized_angle := false

func get_data() -> String:
	var data = (
		get_atk_str(damage) + "\n" +
		get_cd_str(fire_timer.base_cooldown) + "\n" +
		get_general_str("Bullets", projectile_count) + "\n" +
		get_pierce_str(pierce)
	)
	return data

func set_data(_damage: float, _cooldown: float, _count: int, _pierce: int) -> void:
	if _damage: damage = _damage
	if _cooldown: fire_timer.base_cooldown = _cooldown
	if _count: projectile_count = _count
	if _pierce: pierce = _pierce

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_data(2, 3, 4, 1)
		2:
			set_data(0, 0, 6, 2)
		3:
			set_data(4, 0, 0, 0)
		4:
			set_data(0, 0, 8, 3)
		5:
			set_data(0, 2, 0, 0)
			randomized_angle = true
		6:
			set_data(0, 0, 16, 0)

func _on_fire_timer_timeout():
	AudioSystem.play_sfx(hit_sfx, ai.global_position)

	var angle_delta := 0.0
	if randomized_angle:
		angle_delta = randf() * TAU

	for i in range(projectile_count):
		var fireball = fireball_template.instantiate()
		var angle = 2 * PI / projectile_count * i + angle_delta
		fireball.setup(speed, damage, Vector2.RIGHT.rotated(angle), pierce)
		fireball.global_position = ai.global_position
		map.add_child(fireball)
