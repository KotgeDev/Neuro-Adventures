extends Control

var ui_Active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2.ZERO

func _set_scale_zero():
	scale = Vector2.ZERO
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(scale)
	if ui_Active:
		scale += Vector2.ONE*delta*5
		scale = clamp(scale, Vector2.ZERO, Vector2.ONE)
