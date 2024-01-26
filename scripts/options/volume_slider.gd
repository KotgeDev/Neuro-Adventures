extends HSlider

@export var bus_name := "Music"

@onready var bus_index = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	value_changed.connect(_on_music_slider_value_changed)
	if bus_name == "Music": 
		value = SetOptions.music_volume 
	elif bus_name == "Sfx": 
		value = SetOptions.music_volume

func _on_music_slider_value_changed(value: float):
	if bus_name == "Music": 
		SetOptions.music_volume = value 
	elif bus_name == "Sfx": 
		SetOptions.music_volume = value 
	
	AudioServer.set_bus_volume_db(
		bus_index, 
		linear_to_db(value)
	)

