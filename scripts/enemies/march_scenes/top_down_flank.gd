extends March

@onready var marker2d = $Markers/Marker2D

const INIT_X = 50.0
const TOP_Y = 50.0
const BOTTOM_Y = 600.0 

func setup_markers() -> void:
	continuous = false 
	marker2d.global_position = Vector2(INIT_X, TOP_Y)
	marker2d.transform.x = Vector2(0, 1)
	
	var marker2d2 = marker2d.duplicate()
	marker2d2.global_position = Vector2(INIT_X, BOTTOM_Y)
	markers.add_child(marker2d2)
	
	for i in range(24):
		var step: float = (i+1) * 100.0
		
		var top_marker = marker2d.duplicate()
		top_marker.global_position = Vector2(INIT_X + step, TOP_Y)
		top_marker.transform.x = Vector2(0, 1)
		markers.add_child(top_marker) 
		
		var bottom_marker = marker2d.duplicate()
		bottom_marker.global_position = Vector2(INIT_X + 50.0 + step, BOTTOM_Y)
		bottom_marker.transform.x = Vector2(0, -1)
		markers.add_child(bottom_marker) 
