extends HSlider

@export var bus_name := "music"

@onready var bus_index = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	value_changed.connect(_on_value_changed)

	if bus_name == "music":
		value = SettingsManager.settings.music_volume
	elif bus_name == "soundfx":
		value = SettingsManager.settings.sfx_volume

func _on_value_changed(value: float):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)

	if bus_name == "music":
		SettingsManager.settings.music_volume = value
	elif bus_name == "soundfx":
		SettingsManager.settings.sfx_volume = value
