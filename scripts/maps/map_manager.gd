extends Node

enum MapMode {
	NORMAL, 
	HARD,
	ENDLESS 
}

var map_mode: MapMode

## Must be called before the start of every game 
func setup(mode: MapMode) -> void:
	map_mode = mode
