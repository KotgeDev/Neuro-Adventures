extends UpgradeScene

var portal_template = preload("res://scenes/projectiles/portal.tscn")

@export var LV1_BASE_COOLDOWN := 12.0 
@export var LV2_BASE_COOLDOWN := 10.0 
@export var LV3_BASE_COOLDOWN := 8.0
@export var LV4_BASE_COOLDOWN := 6.0
@export var LV5_BASE_COOLDOWN := 5.0 

@onready var map = get_tree().get_first_node_in_group("map")
@onready var anny = get_parent() 
@onready var navi_agent: NavigationAgent2D = get_tree().get_first_node_in_group("ai").navigation_agent
@onready var sprite = $PortalGun
@onready var loading_timer = $LoadingTimer
@onready var anny_portal = $Portal
@onready var warning_label = $WarningLabel

var base_loading_time := LV1_BASE_COOLDOWN  
var teleport_available := false 

var portal_sfx: AudioStream = preload("res://assets/sfx/annyteleport.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	sync_level()
	loading_timer.wait_time = base_loading_time
	loading_timer.start()
	
	#ai.add_child(ai_portal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ability") and teleport_available:
		teleport()

func teleport() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var area_legal = mouse_pos == NavigationServer2D.map_get_closest_point(navi_agent.get_navigation_map(), mouse_pos) 
	
	if area_legal: 
		var anny_pos: Vector2 = anny.global_position
		sprite.visible = false 
		teleport_available = false 
		loading_timer.wait_time = base_loading_time + anny_pos.distance_squared_to(mouse_pos) * 0.0002
		loading_timer.start()
		anny.global_position = mouse_pos
		anny_portal.play_animation() 
		AudioSystem.play_sfx(portal_sfx, global_position)
	else:
		warning_label.visible = true 
		await get_tree().create_timer(3.0).timeout 
		warning_label.visible = false 
	
func _on_loading_timer_timeout():
	loading_timer.stop()
	sprite.visible = true
	teleport_available = true 

func sync_level() -> void:
	match upgrade.lvl:
		2:
			base_loading_time = LV2_BASE_COOLDOWN
		3:
			base_loading_time = LV3_BASE_COOLDOWN
		4:
			base_loading_time = LV4_BASE_COOLDOWN
		5:
			base_loading_time = LV5_BASE_COOLDOWN
