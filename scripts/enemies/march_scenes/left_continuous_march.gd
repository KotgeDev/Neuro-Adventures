extends March

@onready var marker2d = $Markers/Marker2D

const INIT_X = 50
const INIT_Y = 50 

func setup_markers() -> void:
	continuous = true 
	marker2d.global_position = Vector2(INIT_X, INIT_Y)
	for i in range(11):
		var marker = marker2d.duplicate()
		var step: float = (i+1) * 50
		marker.global_position = Vector2(INIT_X, INIT_Y + step)
		
		markers.add_child(marker) 
	
