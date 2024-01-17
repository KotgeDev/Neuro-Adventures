extends March

@onready var marker2d = $Markers/Marker2D

const LEFT_X = 25
const RIGHT_X = 2500
const INIT_Y = 30 

func setup_markers() -> void:
	marker2d.global_position = Vector2(LEFT_X, INIT_Y)
	
	var marker2d_right = marker2d.duplicate()
	marker2d_right.global_position = Vector2(RIGHT_X, INIT_Y)
	marker2d_right.global_rotation = deg_to_rad(180.0)
	markers.add_child(marker2d_right)
	
	for i in range(12):
		var step: float = (i+1) * 50
		
		var marker = marker2d.duplicate()
		marker.global_position = Vector2(LEFT_X, INIT_Y + step)
		markers.add_child(marker) 
		
		var marker_right = marker2d.duplicate()
		marker_right.global_rotation = deg_to_rad(180.0)
		marker_right.global_position = Vector2(RIGHT_X, INIT_Y + step)
		markers.add_child(marker_right) 
