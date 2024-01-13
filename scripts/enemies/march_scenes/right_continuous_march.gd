extends March

@onready var marker2d = $Markers/Marker2D

const INIT_X = 2500
const INIT_Y = 50 
const RIGHT_TRANSFORM = Vector2(-1, 0)

func setup_markers() -> void:
	continuous = true 
	marker2d.global_position = Vector2(INIT_X, INIT_Y)
	marker2d.transform.x = RIGHT_TRANSFORM
	
	for i in range(11):
		var marker = marker2d.duplicate()
		var step: float = (i+1) * 50
		marker.global_position = Vector2(INIT_X, INIT_Y + step)
		marker.transform.x = RIGHT_TRANSFORM
		
		markers.add_child(marker) 
	
