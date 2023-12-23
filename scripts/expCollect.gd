extends Area2D
class_name ExpCollect  
var is_collection = false
var collab_partner 
var current_y_pos
var floating = 1.55334
func _ready() -> void:
	current_y_pos = global_position.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	collab_partner = get_tree().get_first_node_in_group("collab_partner")
	var distance = collab_partner.global_position.distance_to(global_position)
	if(distance < 2):
		queue_free()
	elif(distance > 2 && distance < 50):
		var dir = collab_partner.global_position - global_position
		dir = dir.normalized()
		
		global_position += 120*dir*delta
	else:
		floating += delta*5
		global_position = Vector2(global_position.x,current_y_pos + (sin(floating)*2))
	pass
