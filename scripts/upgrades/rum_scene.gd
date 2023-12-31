extends UpgradeScene

var rum_template = preload("res://scenes/projectiles/rum.tscn")

#region CONSTANTS
@export_category("Rum Scene")
@export var SPEED := 100 
@export var DAMAGE := 2 
@export var LV1_SPLASH := false 
@export var LV2_SPLASH := true 
@export var LV1_FIRE_INTERVAL := 1.0 
@export var LV3_FIRE_INTERVAL := 0.5
@export var LV1_SPLASH_DAMAGE_DURATION := 4.2
@export var LV4_SPLASH_DAMAGE_DURATION := 6.2
@export var LV1_SPLASH_DAMAGE_INTERVAL := 0.5
@export var LV4_SPLASH_DAMAGE_INTERVAL := 0.25
@export var SPLASH_DAMAGE := 1.0 
#endregion 

#region NODES
@onready var fire_location = $FireLocation
@onready var collab_partner = get_parent()
@onready var map = get_parent().get_parent()
@onready var fire_timer = $FireTimer
#endregion 

func _ready() -> void:
	sync_level()
	fire_timer.wait_time = LV1_FIRE_INTERVAL

func _on_fire_timer_timeout():		
	if collab_partner.velocity > Vector2.ZERO: 
		fire_location.position = Vector2(8, 5)
	elif collab_partner.velocity < Vector2.ZERO:
		fire_location.position = Vector2(-8, 5)
	
	var rum = rum_template.instantiate()
	rum.global_position = fire_location.global_position
	
	match upgrade.lvl: 
		1: 
			rum.setup(SPEED, DAMAGE, LV1_SPLASH, LV1_SPLASH_DAMAGE_DURATION, LV1_SPLASH_DAMAGE_INTERVAL, SPLASH_DAMAGE) 
		2: 
			rum.setup(SPEED, DAMAGE, LV2_SPLASH, LV1_SPLASH_DAMAGE_DURATION, LV1_SPLASH_DAMAGE_INTERVAL, SPLASH_DAMAGE)
		3:
			rum.setup(SPEED, DAMAGE, LV2_SPLASH, LV1_SPLASH_DAMAGE_DURATION, LV1_SPLASH_DAMAGE_INTERVAL, SPLASH_DAMAGE)
		4:
			rum.setup(SPEED, DAMAGE, LV2_SPLASH, LV4_SPLASH_DAMAGE_DURATION, LV4_SPLASH_DAMAGE_INTERVAL, SPLASH_DAMAGE)
		
	map.add_child(rum)

func sync_level() -> void:	
	if upgrade.lvl >= 3: 
		fire_timer.wait_time = LV3_FIRE_INTERVAL
