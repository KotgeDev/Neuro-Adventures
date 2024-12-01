extends Node

enum MapMode {
	NORMAL, 
	HARD,
	ENDLESS 
}

var map_mode: MapMode

var map_data = {
	Globals.MapChoice.THE_FARM: MapData.new("The Farm")
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

## Must be called before the start of every game 
func setup(mode: MapMode) -> void:
	map_mode = mode

func get_names() -> Array: 
	var names_array = []
	
	for data in map_data: 
		names_array.append(map_data[data].map_name)

	return names_array 
