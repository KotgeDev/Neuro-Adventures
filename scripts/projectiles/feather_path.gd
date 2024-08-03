extends Node2D

@export var SPEED := 400.0 
@export var WARNING_TIME := 1.5

@onready var timeout = 3000.0 / SPEED + WARNING_TIME 
@onready var ai: AI = get_tree().get_first_node_in_group("ai")
@onready var anim = $AnimationPlayer
@onready var color_rect = $ColorRect

var feather_template = preload("res://scenes/projectiles/feather.tscn")
var feather_sfx: AudioStream = preload("res://assets/sfx/arrowswish.wav")
var damage: float 
var hit_count: int 

func setup(p_damage: float, p_hit_count) -> void:
	damage = p_damage
	hit_count = p_hit_count

func _ready() -> void:
	anim.play("pulse")
	
	await get_tree().create_timer(WARNING_TIME, false).timeout
	
	color_rect.visible = false

	AudioSystem.play_sfx(feather_sfx, ai.global_position)
	
	var feather = feather_template.instantiate()
	feather.destroyed.connect(self_destruct)
	add_child(feather)
	feather.global_position = self.global_position 
	feather.setup(global_rotation, SPEED, damage, hit_count, timeout)
	
func self_destruct():
	queue_free()
