extends UpgradeScene

var rum_template = preload("res://scenes/projectiles/rum.tscn")

#region CONSTANTS
@export_category("Rum Scene")
@export var BASE_SPEED := 100 
@export var BASE_RUM_DAMAGE := 1.0
@export var BASE_SPLASH_DAMAGE := 1.0
@export var LV1_FIRE_INTERVAL := 1.5
@export var LV1_SPLASH_DAMAGE_DURATION := 2.2
@export var LV1_SPLASH_DAMAGE_INTERVAL := 1.0
@export var LV1_STUN := 0.4
@export var LV2_STUN := 1.0
@export var LV3_FIRE_INTERVAL := 1.0
@export var LV4_SPLASH_DAMAGE_DURATION := 3.2
@export var LV4_SPLASH_DAMAGE_INTERVAL := 0.5
@export var LV5_STUN := 3.0
#endregion 

#region NODES
@onready var fire_location = $FireLocation
@onready var collab_partner = get_parent()
@onready var map = get_parent().get_parent()
@onready var fire_timer = $FireTimer
#endregion 

var speed: float 
var rum_damage: float
var splash_damage: float 
var fire_interval: float 
var splash_damage_duration: float 
var splash_damage_interval: float 
var stun: float 

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/vedal_throw.wav")
#endregion 

func _on_fire_timer_timeout():		
	#i fixed the rum throwing location. it now throws from vedal's hand, and in the correct direction. -that one guy
	if not collab_partner.character_animation.run_sprite.flip_h: 
		fire_location.position = Vector2(10, -7)
	else:
		fire_location.position = Vector2(-10, -7)
	
	var rum = rum_template.instantiate()
	rum.global_position = fire_location.global_position
	
	rum.setup(
		speed, 
		rum_damage, 
		splash_damage_duration, 
		splash_damage_interval, 
		splash_damage,
		stun) 

	map.add_child(rum)
	
	AudioSystem.play_sfx(hit_sfx, collab_partner.global_position, 1.0)

func sync_level() -> void:	
	match upgrade.lvl: 
		1:
			speed = BASE_SPEED
			fire_timer.base_cooldown = LV1_FIRE_INTERVAL
			splash_damage = BASE_SPLASH_DAMAGE
			rum_damage = BASE_RUM_DAMAGE
			stun = LV1_STUN
			splash_damage_duration = LV1_SPLASH_DAMAGE_DURATION
			splash_damage_interval = LV1_SPLASH_DAMAGE_INTERVAL
		2:
			stun = LV2_STUN 
		3:
			fire_timer.base_cooldown = LV3_FIRE_INTERVAL
		4:
			splash_damage_duration = LV4_SPLASH_DAMAGE_DURATION
			splash_damage_interval = LV4_SPLASH_DAMAGE_INTERVAL
		5:
			stun = LV5_STUN
