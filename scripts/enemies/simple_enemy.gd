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
@export var BASE_MAX_HEALTH := 1.0
@export var BASE_MAX_SPEED := 1.0
@export var BASE_DAMAGE := 1.0
@export var ATTACK_INTERVAL := 1.0
#endregion 

#region NODES
@onready var sprite_2d = $Sprite2D
@onready var stun_effect = $StunEffect
@onready var map = get_tree().get_first_node_in_group("map") as MAP
@onready var navigation_agent = $NavigationAgent2D
@onready var pathfind_timer = $PathfindTimer
@onready var effect_player = $EffectPlayer
@onready var collab_partner: CollabPartner = get_tree().get_first_node_in_group("collab_partner")
@onready var ai: AI = get_tree().get_first_node_in_group("ai")
#endregion 

#region TEMPLATES
var expp_template = preload("res://scenes/collectibles/exp.tscn")
var ntx_template = preload("res://scenes/interactive_objects/ntx_4090.tscn")
#endregion

#region STATS
@onready var health := BASE_MAX_HEALTH 
@onready var max_speed := BASE_MAX_SPEED 
@onready var damage := BASE_DAMAGE
#endregion 

#region OTHER 
var velocity: Vector2
var next_pos: Vector2
var dead := false 
var last_enemy := false 
var last_flip_time: float
var stunned := false 
#endregion 

#region MARCH
var march := false 
var march_direction: Vector2
var march_duration: float 
#endregion 

func set_stats() -> void:
	match MapManager.map_mode:
		MapManager.MapMode.NORMAL:
			pass 
		MapManager.MapMode.HARD:
			health = BASE_MAX_HEALTH * 2  
			damage = BASE_DAMAGE * 2
		MapManager.MapMode.ENDLESS:
			pass  

func ready() -> void:
	pathfind_timer.wait_time = 0.5
	pathfind_timer.start()
	$ContinuousHitbox.damage = damage 
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
	if stunned:
		return
	
	if march:
		velocity = march_direction * max_speed 
	else:
		var dir = to_local(next_pos).normalized()
		velocity = dir * max_speed    
	
	if last_flip_time > 0:
		last_flip_time -= delta 
	else:
		sprite_2d.flip_h = velocity.x < 0 
		stun_effect.flip_h = velocity.x < 0
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
		
		for generator in map.collectible_generators: 
			var random_number = randf()
			if random_number <= generator.drop_chance:
				var collectible = generator.collectible_scene.instantiate()
				collectible.global_position = global_position
				map.call_deferred("add_child", collectible) 
				already_dropped_item = true 

		if not already_dropped_item:
			var expp = expp_template.instantiate() 
			expp.global_position = global_position
			map.call_deferred("add_child", expp)
		
		var ntx_num = randf_range(0, 100)
		if map.enemies_killed_since_last_ntx < map.NTX_REQ: 
			map.enemies_killed_since_last_ntx += 1
		elif map.NTX_REQ <= map.enemies_killed_since_last_ntx && map.enemies_killed_since_last_ntx < map.PITY_REQ:
			if ntx_num <= map.ntx_chance:
				spawn_ntx_4090()
			else: 
				map.ntx_chance = map.BASE_NTX_CHANCE
				map.enemies_killed_since_last_ntx += 1 
		elif map.PITY_REQ <= map.enemies_killed_since_last_ntx:
			if ntx_num <= map.ntx_chance:
				spawn_ntx_4090()
			else:
				map.ntx_chance += map.PITY_STEP 
				map.enemies_killed_since_last_ntx += 1 
		
		queue_free() 

func spawn_ntx_4090() -> void:
	map.ntx_chance = map.BASE_NTX_CHANCE
	map.enemies_killed_since_last_ntx = 0 
	
	var ntx = ntx_template.instantiate()
	ntx.global_position = global_position
	map.call_deferred("add_child", ntx) 

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

func stun(stun_time: float) -> void:
	stun_effect.visible = true
	$AnimationPlayer.stop()
	effect_player.play("stunned")
	stunned = true 
	await get_tree().create_timer(stun_time, false).timeout
	stunned = false 
	stun_effect.visible = false
	$AnimationPlayer.play("idle")
	effect_player.stop()
