extends Node

signal save_settings 
signal save_default_upgrades

enum WindowMode {
	FULL_SCREEN,
	WINDOWED,
	BORDERLESS_WINDOW,
	BORDERLESS_FULL_SCREEN
}

enum CollabPartnerSelection {
	VEDAL,
	ANNY
}

enum AISelection {
	NEURO,
	EVIL 
}

var save_path = "user://settings.save"
var default_upgrades_save_path = "user://default_upgrades.save"

#region SETTINGS
var settings := {
	"window_mode": WindowMode.WINDOWED,
	"sfx_volume": 1.0,
	"music_volume": 1.0,
	"fps_counter": false,
	"full_health_effect": true,
	"ai_selected": Globals.CharacterChoice.NEURO,
	"collab_partner_selected": Globals.CharacterChoice.VEDAL,
}
var default_upgrades := {
	Globals.CharacterChoice.NEURO: ["Dual Strike", "Cookies"],
	Globals.CharacterChoice.VEDAL: ["Rum", "Creggs"],
	Globals.CharacterChoice.EVIL: ["Soul Stealer", "Knife"],
	Globals.CharacterChoice.ANNY: ["Star", "Portal"]
}
#endregion 

func _ready() -> void:
	save_settings.connect(_on_save_settings)
	save_default_upgrades.connect(_on_save_default_upgrades)
	load_data() 
	set_default_settings()

func load_data() -> void:	
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		settings = file.get_var()
	else:
		_on_save_settings()
	
	if FileAccess.file_exists(default_upgrades_save_path):
		var file = FileAccess.open(default_upgrades_save_path, FileAccess.READ)
		default_upgrades = file.get_var() 
	else: 
		_on_save_default_upgrades() 
	
func _on_save_settings() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(settings)

func _on_save_default_upgrades() -> void: 
	var file = FileAccess.open(default_upgrades_save_path, FileAccess.WRITE)
	file.store_var(default_upgrades) 

func set_default_settings() -> void:
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
		SavedOptions.WindowMode.FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SavedOptions.WindowMode.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SavedOptions.WindowMode.BORDERLESS_WINDOW:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		SavedOptions.WindowMode.BORDERLESS_FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true) 
		
