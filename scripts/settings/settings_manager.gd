extends Node

signal save_settings
signal save_default_upgrades

enum WindowMode {
	FULL_SCREEN,
	WINDOWED,
	BORDERLESS_WINDOW,
	BORDERLESS_FULL_SCREEN
}

var save_path = "user://settings.json"
var default_upgrades_save_path = "user://default_upgrades.save"

#region SETTINGS
# When loading data, consider that
# JSON will convert all keys to strings
# and all integers to floats.
var settings := Settings.new()

var default_upgrades := {
	Globals.CharacterChoice.NEURO: ["Dual Strike", "Cookies"],
	Globals.CharacterChoice.VEDAL: ["Rum", "Creggs"],
	Globals.CharacterChoice.EVIL: ["Soul Stealer", "Knife"],
	Globals.CharacterChoice.ANNY: ["Star", "Portal"]
}
#endregion

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	save_settings.connect(save_data)
	save_default_upgrades.connect(save_data)
	load_data()
	set_settings()

func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var json_string := file.get_line()
		file.close()

		var data = JSON.parse_string(json_string)
		assert(data, "Failed to parse json_string")

		settings = Settings.from_dict(data["settings"])
		default_upgrades = convert_keys_to_int(data["default_upgrades"])
	else:
		save_data()

func save_data() -> void:
	var data = {
		"settings": settings.to_dict(),
		"default_upgrades": default_upgrades
	}

	var json_string := JSON.stringify(data)

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_line(json_string)

	file.close()

func set_settings() -> void:
	set_window_mode(settings.window_mode)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("music"),
		linear_to_db(settings.music_volume)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("soundfx"),
		linear_to_db(settings.sfx_volume)
	)

func set_window_mode(index) -> void:
	match index:
		SettingsManager.WindowMode.FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SettingsManager.WindowMode.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SettingsManager.WindowMode.BORDERLESS_WINDOW:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		SettingsManager.WindowMode.BORDERLESS_FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func convert_keys_to_int(dict: Dictionary) -> Dictionary:
	var new_dict = {}

	for key in dict:
		new_dict[int(key)] = dict[key]

	return new_dict
