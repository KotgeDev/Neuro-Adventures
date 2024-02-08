## Parent class for Simple Enemies. Simple enemies
## are enemy types that have a single looping idle animation
## and attacks by targeting the AI and using a continuous hitbox. 
## To create a new Simple Enemy, create a new inherited scene
## using the SimpleEnemy scene 
## Add an AnimationPlayer with an animation named idle
## Set Sprite
## Set Hurtbox CollsionPolygon, 
## Set ContinuousHitbox settings and CollisionPolygon 
## Set CollisionShape2D
extends Enemy
class_name SimpleEnemy 

#region CONSTANTS
@export var SPEED := 25.0
@export var MAX_HEALTH := 1.0
@export var DAMAGE := 1.0
@export var ATTACK_INTERVAL := 1.0
@export var PATH_FIND_INTERVAL := 0.5 
#endregion 

#region NODES
@onready var sprite_2d = $Sprite2D
@onready var map = get_tree().get_first_node_in_group("map") as MAP
#endregion 

#region NAVIGATION
@onready var navigation_agent = $NavigationAgent2D
#endregion 

#region OTHER
var velocity: Vector2
var next_pos: Vector2
var cookie_template = preload("res://scenes/collectibles/cookie.tscn")
var creggs_template = preload("res://scenes/collectibles/creggs.tscn")
var expp_template = preload("res://scenes/collectibles/exp.tscn")
var ntx_template = preload("res://scenes/interactive_objects/ntx_4090.tscn")
var last_enemy := false 
var last_flip_time: float
#endregion 

#region MARCH
var march := false 
var march_direction: Vector2
var march_duration: float 
#endregion 

@onready var health: int = MAX_HEALTH  
@onready var collab_partner: CollabPartner = get_tree().get_first_node_in_group("collab_partner")
@onready var ai: AI = get_tree().get_first_node_in_group("ai")
var dead := false 

func ready() -> void: 
	$PathfindTimer.wait_time = PATH_FIND_INTERVAL
	$PathfindTimer.start()
	$ContinuousHitbox.damage = DAMAGE 
	$ContinuousHitbox/HitTimer.wait_time = ATTACK_INTERVAL
	$AnimationPlayer.play("idle")
	
	if march: 
		$MarchDuration.wait_time = march_duration 
		$MarchDuration.start()
	else:
		if(global_position.distance_to(collab_partner.global_position) < 350.0):
			make_path()
		else:
			next_pos = ai.global_position

func make_path() -> void:
	navigation_agent.target_position = ai.global_position
	next_pos = navigation_agent.get_next_path_position()

func _physics_process(delta):
	if march: 
		velocity = march_direction * SPEED 
	else:
		var dir = to_local(next_pos).normalized()
		velocity = dir * SPEED    
	
	if last_flip_time > 0:
		last_flip_time -= delta 
	else:
		sprite_2d.flip_h = velocity.x < 0 
		last_flip_time = 0.5
	
	position += velocity * delta 

func _on_hurtbox_take_damage(damage):
	health -= damage
	sprite_2d.modulate = Color("b4244a")
	await get_tree().create_timer(0.05).timeout 
	sprite_2d.modulate = Color("ffffff") 
	
	if health <= 0 and not dead:
		dead = true 
		
		var already_dropped_item := false 
		
		var cookie_num = randf()
		if cookie_num <= ai.cookie_drop_chance:
			var cookie = cookie_template.instantiate()
			cookie.global_position = global_position
			map.call_deferred("add_child", cookie)
			already_dropped_item = true 
			
		var creggs_num = randf()
		if creggs_num <= collab_partner.creggs_drop_chance:
			var creggs = creggs_template.instantiate()
			creggs.global_position = global_position
			map.call_deferred("add_child", creggs)
			already_dropped_item = true 
			
		if not already_dropped_item:
			var expp = expp_template.instantiate() 
			expp.global_position = global_position
			map.call_deferred("add_child", expp)
		
		var ntx_num = randf_range(0, 100)
		if ntx_num <= map.ntx_chance:
			map.ntx_chance = map.NTX_BASE_CHANCE
			var ntx = ntx_template.instantiate()
			ntx.global_position = global_position
			map.call_deferred("add_child", ntx)
		else:
			map.ntx_chance += map.NTX_STEP 
		
		queue_free() 

func _on_pathfind_timer_timeout():
	if march:
		return
	else: 
		if(global_position.distance_to(collab_partner.global_position) < 350.0):
			make_path()
		else:
			next_pos = ai.global_position

func _on_march_duration_timeout():
	queue_free()
