extends Node2D

var splash_template = preload("res://scenes/projectiles/rum_splash.tscn")

#region NODES
@onready var multi_hitbox = $MultiHitbox
@onready var map = get_tree().get_first_node_in_group("map")
#endregion

#region PROPERTIES
var speed: int 
var create_splash: bool
var duration: float 
var hit_wait_time: float 
var splash_damage: float 
#endregion 

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/RumHit.wav")
#endregion 

func _ready() -> void:
	$AnimationPlayer.play("spin")
	look_at(get_global_mouse_position())

func setup(
	p_speed: int,
	p_damage: int, 
	p_create_splash: bool, 
	p_duration: float, 
	p_hit_wait_time: float,
	p_splash_damage: float
) -> void: 
	speed = p_speed
	$MultiHitbox.damage = p_damage
	create_splash = p_create_splash
	duration = p_duration
	hit_wait_time = p_hit_wait_time
	splash_damage = p_splash_damage

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta    

func _on_multi_hitbox_self_destruct():
	speed = 0
	if create_splash: add_splash()
	$AnimationPlayer.play("hit")
	Audiosystem.play_sfx(hit_sfx, global_position)
	await $AnimationPlayer.animation_finished
	queue_free()

func add_splash() -> void: 
	var rum_splash = splash_template.instantiate() 
	rum_splash.global_position = global_position
	rum_splash.setup(duration, hit_wait_time, splash_damage)
	map.call_deferred("add_child", rum_splash)
