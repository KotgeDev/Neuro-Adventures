extends UpgradeScene

var portal_template = preload("res://scenes/projectiles/portal.tscn")

@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME)
@onready var anny = get_parent()
@onready var navi_agent: NavigationAgent2D = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME).navigation_agent
@onready var sprite = $PortalGun
@onready var loading_timer = $LoadingTimer
@onready var anny_portal = $Portal
@onready var warning_label = $WarningLabel

var base_loading_time: float
var teleport_available := false

var portal_sfx: AudioStream = preload("res://assets/sfx/annyteleport.wav")

func get_data() -> String:
	return (
		get_cd_str(base_loading_time)
	)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			base_loading_time = 12.0

			loading_timer.base_cooldown = base_loading_time
			loading_timer.start()
		2:
			base_loading_time = 10.0
		3:
			base_loading_time = 8.0
		4:
			base_loading_time = 6.0
		5:
			base_loading_time = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ability") and teleport_available:
		teleport()

func teleport() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var nav_pos = NavigationServer2D.map_get_closest_point(navi_agent.get_navigation_map(), mouse_pos)

	var anny_pos: Vector2 = anny.global_position
	sprite.visible = false
	teleport_available = false
	loading_timer.base_cooldown = base_loading_time + anny_pos.distance_squared_to(mouse_pos) * 0.0002
	loading_timer.start()
	anny.global_position = nav_pos
	anny_portal.play_animation()
	AudioSystem.play_sfx(portal_sfx, global_position)
		#warning_label.visible = true
		#await get_tree().create_timer(3.0, false).timeout
		#warning_label.visible = false

func _on_loading_timer_timeout():
	loading_timer.stop()
	sprite.visible = true
	teleport_available = true
