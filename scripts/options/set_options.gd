extends Node

enum WindowMode {
	FULL_SCREEN,
	WINDOWED,
	BORDERLESS_WINDOW,
	BORDERLESS_FULL_SCREEN
}

var window_mode := WindowMode.WINDOWED
var sfx_volume := 0.0
var music_volume := 0.0
