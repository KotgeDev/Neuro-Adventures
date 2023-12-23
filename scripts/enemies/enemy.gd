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
extends CharacterBody2D
class_name SimpleEnemy 

var expp_template = preload("res://scenes/upgrades/exp.tscn")
var last_enemy := false 

#region CONSTANTS
@export var SPEED := 25.0
@export var MAX_HEALTH := 2
@export var DAMAGE := 2.0
@export var ATTACK_INTERVAL := 0.4
#endregion 

#region NODES
@onready var compass = $Compass
@onready var sprite_2d = $Sprite2D
#endregion 

@onready var health: int = MAX_HEALTH  
var dead := false 


func _ready() -> void: 
	$ContinuousHitbox.damage = DAMAGE 
	$ContinuousHitbox/HitTimer.wait_time = ATTACK_INTERVAL
	$AnimationPlayer.play("idle")

func _physics_process(_delta):
	var target_pos = get_tree().get_first_node_in_group("ai").global_position
	var difference = abs((global_position - target_pos).length())
	if difference > 3: 
		compass.look_at(target_pos)
		velocity = compass.transform.x * SPEED    
	
	if velocity.x < 0: 
		sprite_2d.flip_h = true 
	elif velocity.x > 0:
		sprite_2d.flip_h = false 
	
	move_and_slide()

func _on_hurtbox_take_damage(damage):
	health -= damage
	sprite_2d.modulate = Color("b4244a")
	await get_tree().create_timer(0.05).timeout 
	sprite_2d.modulate = Color("ffffff") 
	
	if health <= 0 and not dead:
		dead = true 
		var expp = expp_template.instantiate() 
		expp.global_position = global_position
		get_parent().call_deferred("add_child", expp)
		
		if last_enemy:
			Globals.game_won.emit() 
		
		queue_free() 
