extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var multi_hitbox = $MultiHitbox
@onready var charged_damage_timer = $ChargedDamageTimer
@onready var sprite_2d = $Sprite2D
@onready var star_upgrade = get_parent().get_parent() 

var star_sfx: AudioStream = preload("res://assets/sfx/annysparkle.wav")

const INIT_ROTATION_SPEED := 1  
const ACCEL := 20
const RADIUS := 40.0 

#region PROPERTIES
var rotation_speed := INIT_ROTATION_SPEED
var max_rotation_speed := INIT_ROTATION_SPEED
var base_damage: float 
var hit_enemy := false 
var angle := 0.0 
#endregion

func _ready() -> void:
	Globals.update_stars.connect(_on_update_stars)
	
func _physics_process(delta) -> void:
	if not hit_enemy: 
		angle += rotation_speed * delta 
		position = Vector2(RADIUS * cos(angle), RADIUS * sin(angle))
	
	rotation_speed = lerp(rotation_speed, max_rotation_speed, ACCEL * delta)
	
func setup(p_damage, p_charge_timer, p_angle) -> void:
	base_damage = p_damage 
	multi_hitbox.damage = base_damage
	charged_damage_timer.wait_time = p_charge_timer
	charged_damage_timer.start()
	
	angle = p_angle 
	position = Vector2(RADIUS * cos(p_angle), RADIUS * sin(p_angle))

func _on_multi_hitbox_self_destruct():
	if not hit_enemy:
		AudioSystem.play_sfx(star_sfx, global_position, 0.3)
		hit_enemy = true 
		animation_player.play("explosion")
		await animation_player.animation_finished
		queue_free() 

func _on_update_stars(enemy_in_range: bool):
	if enemy_in_range:
		max_rotation_speed = INIT_ROTATION_SPEED * 5
	else: 
		max_rotation_speed = INIT_ROTATION_SPEED

func _on_charged_damage_timer_timeout():
	multi_hitbox.damage *= 2 
	sprite_2d.material = load("res://assets/shaders/rainbow.tres")
	sprite_2d.material.set_shader_parameter("strength", 0.5)
