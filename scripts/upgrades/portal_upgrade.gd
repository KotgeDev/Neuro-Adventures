extends UpgradeScene

var portal_template = preload("res://scenes/projectiles/portal.tscn")

@export var LV1_BASE_COOLDOWN := 12.0 
@export var LV2_BASE_COOLDOWN := 10.0 
@export var LV3_BASE_COOLDOWN := 8.0
@export var LV4_BASE_COOLDOWN := 6.0
@export var LV5_BASE_COOLDOWN := 5.0 

@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME)
@onready var anny = get_parent() 
@onready var navi_agent: NavigationAgent2D = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME).navigation_agent
@onready var sprite = $PortalGun
@onready var loading_timer = $LoadingTimer
@onready var anny_portal = $Portal
@onready var warning_label = $WarningLabel

var base_loading_time := LV1_BASE_COOLDOWN  
var teleport_available := false 

var portal_sfx: AudioStream = preload("res://assets/sfx/annyteleport.wav")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ability") and teleport_available:
		teleport()

func teleport() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var nav_pos = NavigationServer2D.map_get_closest_point(navi_agent.get_navigation_map(), mouse_pos) 
	
	if mouse_in_valid_position(mouse_pos): 
		var anny_pos: Vector2 = anny.global_position
		sprite.visible = false 
		teleport_available = false 
		loading_timer.base_cooldown = base_loading_time + anny_pos.distance_squared_to(mouse_pos) * 0.0002
		loading_timer.start()
		anny.global_position = nav_pos
		anny_portal.play_animation() 
		AudioSystem.play_sfx(portal_sfx, global_position)
	else:
		warning_label.visible = true 
		await get_tree().create_timer(3.0).timeout 
		warning_label.visible = false 

func mouse_in_valid_position(mouse_pos: Vector2): 
	var screen_size = get_viewport().size 
	return mouse_pos.x >= 0 and mouse_pos.x <= screen_size.x and mouse_pos.y >= 0 and mouse_pos.y <= screen_size.y

func _on_loading_timer_timeout():
	loading_timer.stop()
	sprite.visible = true
	teleport_available = true 

func sync_level() -> void:
	match upgrade.lvl:
		1: 
			loading_timer.base_cooldown = base_loading_time
			loading_timer.start()
		2:
			base_loading_time = LV2_BASE_COOLDOWN
		3:
			base_loading_time = LV3_BASE_COOLDOWN
		4:
			base_loading_time = LV4_BASE_COOLDOWN
		5:
			base_loading_time = LV5_BASE_COOLDOWN
