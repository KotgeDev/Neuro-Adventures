extends UpgradeScene 

var fireball_template = preload("res://scenes/projectiles/fireball.tscn")

@onready var ai: AI = get_tree().get_first_node_in_group("ai")
@onready var map: MAP = get_tree().get_first_node_in_group("map")
@onready var fire_timer = $FireTimer

@export_category("Fireball")
@export var BASE_SPEED := 100 
@export var LV1_DAMAGE := 2.0
@export var LV1_WAIT_TIME := 2.0
@export var LV1_PIERCE := 2
@export var LV1_PROJECTILE_COUNT := 4
@export var LV2_WAIT_TIME := 1.5
@export var LV3_PROJECTILE_COUNT := 6
@export var LV3_PIERCE := 3 
@export var LV4_DAMAGE := 4.0
@export var LV5_PROJECTILE_COUNT := 8
@export var LV5_PIERCE := 4
@export var LV6_PROJECTILE_COUNT := 20

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/laser_fire.wav")
#endregion 

var speed = BASE_SPEED
var damage = LV1_DAMAGE
var pierce = LV1_PIERCE
var projectile_count = LV1_PROJECTILE_COUNT

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_timer.wait_time = LV1_WAIT_TIME
	sync_level() 

func sync_level() -> void:
	match upgrade.lvl:
		2:
			fire_timer.wait_time = LV2_WAIT_TIME
		3:
			projectile_count = LV3_PROJECTILE_COUNT
			pierce = LV3_PIERCE
			
		4:
			damage = LV4_DAMAGE
		5:
			projectile_count = LV5_PROJECTILE_COUNT
			pierce = LV5_PIERCE
		6:
			projectile_count = LV6_PROJECTILE_COUNT

func _on_fire_timer_timeout():
	AudioSystem.play_sfx(hit_sfx, ai.global_position)
	
	for i in range(projectile_count):
		var fireball = fireball_template.instantiate() 
		var angle = 2 * PI / projectile_count * i 
		fireball.setup(speed, damage, Vector2.RIGHT.rotated(angle), pierce)
		fireball.global_position = ai.global_position
		map.add_child(fireball)
	
