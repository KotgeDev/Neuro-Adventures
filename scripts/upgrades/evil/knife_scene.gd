extends UpgradeScene

var knife_template = preload("res://scenes/projectiles/knife.tscn")

@onready var fire_timer = $FireTimer
@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var damage_zone = $DamageZone

#region CONSTANTS
@export var LV1_DAMAGE = 2.0
@export var LV1_FIRE_INTERVAL = 2.0
@export var LV2_FIRE_INTERVAL = 1.75
@export var LV3_DAMAGE = 4.0
@export var LV4_RANGE_MULTIPLIER = 1.25
@export var LV5_FIRE_INTERVAL = 1.25
@export var LV6_RANGE_MULTIPLIER = 1.5
#endregion

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/knifestab.wav")
#endregion

var damage
var tween

func set_stats(_damage: float, wait_time: float, range_mult: float) -> void:
	if _damage: damage = _damage
	if wait_time: fire_timer.base_cooldown = wait_time
	if range_mult: damage_zone.scale *= range_mult

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_stats(2.0, 2.0, 1.0)
		2:
			set_stats(0, 1.5, 0)
		3:
			set_stats(4.0, 0, 0)
		4:
			set_stats(0, 1.0, 0)
		5:
			set_stats(0, 0, 1.25)

func _on_fire_timer_timeout():
	for area in damage_zone.get_overlapping_areas():
		if is_instance_valid(area) and area:
			var enemy = area.get_parent()
			var knife = knife_template.instantiate()
			add_child(knife)

			# Setup knife
			knife.rotation = global_position.angle_to_point(enemy.global_position)
			knife.global_position = enemy.global_position
			knife.setup(damage)

			AudioSystem.play_sfx(hit_sfx, ai.global_position, 0.5)

			await get_tree().create_timer(0.2, false).timeout
