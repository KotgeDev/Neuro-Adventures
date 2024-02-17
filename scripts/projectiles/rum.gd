extends Node2D

var splash_template = preload("res://scenes/projectiles/rum_splash.tscn")

#region NODES
@onready var multi_hitbox = $MultiHitbox
@onready var map = get_tree().get_first_node_in_group("map")
#endregion

#region PROPERTIES
var speed: int 
var duration: float 
var hit_wait_time: float 
var splash_damage: float 
var stun: float 
#endregion 


func _ready() -> void:
	$AnimationPlayer.play("spin")
	look_at(get_global_mouse_position())

func setup(
	p_speed: int,
	p_damage: int, 
	p_duration: float, 
	p_hit_wait_time: float,
	p_splash_damage: float,
	p_stun: float 
) -> void: 
	speed = p_speed
	$MultiHitbox.damage = p_damage
	duration = p_duration
	hit_wait_time = p_hit_wait_time
	splash_damage = p_splash_damage
	stun = p_stun

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta    

func _on_multi_hitbox_self_destruct():
	speed = 0
	add_splash()
	$AnimationPlayer.play("hit")
	await $AnimationPlayer.animation_finished
	queue_free()

func add_splash() -> void: 
	var rum_splash = splash_template.instantiate() 
	rum_splash.global_position = global_position
	rum_splash.setup(duration, hit_wait_time, splash_damage, stun)
	map.call_deferred("add_child", rum_splash)

func _on_self_destruct_timer_timeout():
	queue_free()
