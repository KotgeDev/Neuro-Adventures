extends Node2D

@export var character: Node

@onready var animation_player = $AnimationPlayer
@onready var idle_sprite = $IdleSprite
@onready var run_sprite = $RunSprite

var running := true 

func _process(delta: float) -> void:
	update_animation(delta) 

func update_animation(delta: float) -> void:
	if character.velocity == Vector2.ZERO: 
		if running:
			running = false  
			animation_player.play("idle")
	else:
		if not running:
			running = true 
			animation_player.play("run") 

	if character.velocity.x < 0: 
		idle_sprite.flip_h = true 
		run_sprite.flip_h = true 
	elif character.velocity.x > 0:
		idle_sprite.flip_h = false 
		run_sprite.flip_h = false 

func show_damage() -> void:
	idle_sprite.material.set_shader_parameter("white", true)
	run_sprite.material.set_shader_parameter("white", true)
	await get_tree().create_timer(Globals.FLASH_TIME).timeout 
	idle_sprite.material.set_shader_parameter("white", false)
	run_sprite.material.set_shader_parameter("white", false)
