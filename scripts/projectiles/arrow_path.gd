extends Node2D

@export var SPEED := 300.0 
@export var DAMAGE := 3.0 
@export var WARNING_TIME := 1.5

@onready var timeout = 3000.0 / SPEED + WARNING_TIME 

var arrow_template = preload("res://scenes/projectiles/arrow.tscn")

func _ready() -> void:
	await get_tree().create_timer(WARNING_TIME).timeout
	
	var arrow = arrow_template.instantiate()
	arrow.destroyed.connect(self_destruct)
	add_child(arrow)
	arrow.global_position = self.global_position 
	arrow.setup(global_rotation, SPEED, DAMAGE, timeout)
	
	var tween = get_tree().create_tween() 
	tween.tween_property($ColorRect, "color:a", 0, WARNING_TIME + 2.0)

func self_destruct():
	queue_free()
