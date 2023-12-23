extends Node2D

@export var character: Node

@onready var animation_tree = $AnimationTree
@onready var idle_sprite = $IdleSprite
@onready var run_sprite = $RunSprite

func _process(delta: float) -> void:
	update_animation() 

func update_animation() -> void: 
	if character.velocity == Vector2.ZERO: 
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_running"] = false
	else: 
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_running"] = true  
	
	if character.velocity.x < 0: 
		idle_sprite.flip_h = true 
		run_sprite.flip_h = true 
	elif character.velocity.x > 0:
		idle_sprite.flip_h = false 
		run_sprite.flip_h = false 

func show_damage() -> void:
	idle_sprite.modulate = Color("b4244a")
	run_sprite.modulate = Color("b4244a")
	await get_tree().create_timer(0.05).timeout 
	idle_sprite.modulate = Color("ffffff") 
	run_sprite.modulate = Color("ffffff") 
