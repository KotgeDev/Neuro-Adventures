extends Enemy
class_name ArcherBoss

#region CONSTANTS
@export var ACCELERATION := 500
@export var FRICTION := 500 
@export var MAX_HEALTH := 500.0
@export var DAMAGE := 12.0
@export var ATTACK_INTERVAL := 1.5
@export var PATH_FIND_INTERVAL := 2.0

@export var PHASE_1_ARROW_INTERVAL := 2.0
@export var PHASE_2_ARROW_INTERVAL := 1.5
@export var PHASE_2_PATTERN_INTERVAL := 4.0 
#endregion 

#region NODES
@onready var sprite_2d = $Sprite2D
@onready var navigation_agent = $NavigationAgent2D
@onready var collab_partner: CollabPartner = get_tree().get_first_node_in_group("collab_partner")
@onready var ai: AI = get_tree().get_first_node_in_group("ai")
@onready var search_field = $SearchField
@onready var animation_player = $AnimationPlayer
@onready var fire_point = $FirePoint
@onready var fire_timer = $FireTimer
@onready var pattern_fire_timer = $PatternFireTimer
#endregion 

#region OTHER
var velocity: Vector2
var current_phase := 1 
var just_started_running := false 
var just_started_shooting := false 
@onready var phase_thresholds := [MAX_HEALTH, MAX_HEALTH * 0.45]
@onready var health: float = MAX_HEALTH  
#endregion 

var arrow_path_template = preload("res://scenes/projectiles/arrow_path.tscn")

func ready() -> void: 
	global_position = Vector2(randi_range(50, 2500), randi_range(50, 600))
	$PathfindTimer.wait_time = PATH_FIND_INTERVAL
	$PathfindTimer.start()
	$ContinuousHitbox.damage = DAMAGE 
	$ContinuousHitbox/HitTimer.wait_time = ATTACK_INTERVAL
	fire_timer.wait_time = PHASE_1_ARROW_INTERVAL
	fire_timer.start()

func make_path() -> void:
	navigation_agent.target_position = ai.global_position

func _physics_process(delta):
	if collab_partner not in search_field.get_overlapping_bodies():
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = velocity.move_toward(dir * max_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
	
	update_animation()
	
	position += velocity * delta 

func update_animation() -> void:
	if velocity == Vector2.ZERO: 
		just_started_running = false 
		if not just_started_shooting:
			animation_player.play("shooting")
			just_started_shooting = true 
	else:
		just_started_shooting = false 
		if not just_started_running:
			animation_player.play("running") 
			just_started_running = true 

	if velocity.x < 0: 
		fire_point.position.x = -13.0
		sprite_2d.flip_h = true 
	elif velocity.x > 0:
		fire_point.position.x = 13.0
		sprite_2d.flip_h = false  
	elif velocity == Vector2.ZERO:
		if global_position.x > ai.global_position.x:
			fire_point.position.x = -13.0
			sprite_2d.flip_h = true
		else:  
			fire_point.position.x = 13.0
			sprite_2d.flip_h = false  

func _on_hurtbox_take_damage(damage):
	health -= damage
	sprite_2d.modulate = Color("b4244a")
	await get_tree().create_timer(0.05).timeout 
	sprite_2d.modulate = Color("ffffff") 
	
	if health <= 0:
		Globals.game_won.emit() 
		queue_free() 

	elif health <= phase_thresholds[1]:
		if current_phase != 2:
			current_phase = 2 
			fire_timer.wait_time = PHASE_2_ARROW_INTERVAL
			pattern_fire_timer.wait_time = PHASE_2_PATTERN_INTERVAL
			pattern_fire_timer.start()

func _on_pathfind_timer_timeout():
	make_path()

func _on_fire_timer_timeout():
	var arrow_path = arrow_path_template.instantiate() 
	arrow_path.global_position = fire_point.global_position
	arrow_path.look_at(ai.global_position) 
	arrow_path.sfx = true 
	get_parent().add_child(arrow_path)

func _on_pattern_fire_timer_timeout():
	if health <= phase_thresholds[1]:
		for i in range(2):
			var fsign: float 
			if i % 2 == 0:
				fsign = -1.0
			else: 
				fsign = 1.0 
			var arrow_path = arrow_path_template.instantiate() 
			var arrow_x: float = ai.global_position.x + ai.global_position.y * fsign
			arrow_path.global_position = Vector2(arrow_x, 0.0)
			arrow_path.look_at(ai.global_position) 
			arrow_path.sfx = true 
			get_parent().add_child(arrow_path)
