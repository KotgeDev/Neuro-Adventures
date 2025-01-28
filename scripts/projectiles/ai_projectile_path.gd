extends Node2D
## A Projectile Path for AI Upgrades
## Launches a projectile along a path
class_name AIProjectilePath

@onready var timeout = 3000.0 / speed + warning_time
@onready var ai: AI = get_tree().get_first_node_in_group("ai")
@onready var anim = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME) as MAP

var damage: float
var speed: float
var warning_time: float
var pierce: int
var projectile_temp: PackedScene
var sfx: AudioStream

## Should be called before adding scene to child
func setup(
	_damage: float,
	_pierce: int,
	_speed: float,
	_warning_time: float,
	_projectile_temp: PackedScene,
	_sfx: AudioStream
) -> void:
	damage = _damage
	pierce = _pierce
	speed = _speed
	warning_time = _warning_time
	projectile_temp = _projectile_temp
	sfx = _sfx

func _ready() -> void:
	# Warning
	anim.play("pulse")
	await get_tree().create_timer(warning_time, false).timeout
	color_rect.visible = false

	# Fire
	var projectile = projectile_temp.instantiate()
	projectile.destroyed.connect(self_destruct)
	projectile.setup(speed, damage, pierce, timeout)
	map.add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation

func self_destruct():
	queue_free()
