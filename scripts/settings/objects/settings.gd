extends Node
class_name Settings

var window_mode: SettingsManager.WindowMode 
var sfx_volume: float 
var music_volume: float
var fps_counter: bool 
var full_health_effect: bool 
var ai_selected: Globals.CharacterChoice 
var collab_partner_selected: Globals.CharacterChoice 
var map_selected: Globals.MapChoice

func _init(
	_window_mode := SettingsManager.WindowMode.WINDOWED,
	_sfx_volume := 1.0, 
	_music_volume := 1.0,
 	_fps_counter := false, 
 	_full_health_effect := true, 
 	_ai_selected := Globals.CharacterChoice.NEURO, 
 	_collab_partner_selected := Globals.CharacterChoice.VEDAL,
	_map_selected := Globals.MapChoice.THE_FARM
) -> void:
	window_mode = _window_mode
	sfx_volume = _sfx_volume
	music_volume = _music_volume
	fps_counter = _fps_counter
	full_health_effect = _full_health_effect
	ai_selected = _ai_selected
	collab_partner_selected = _collab_partner_selected
	map_selected = _map_selected

func to_dict() -> Dictionary:
	var dict = {
		"window_mode": window_mode, 
		"sfx_volume": sfx_volume,
		"music_volume": music_volume, 
		"fps_counter": fps_counter,
		"full_health_effect": full_health_effect,
		"ai_selected": ai_selected,
		"collab_partner_selected": collab_partner_selected,
		"map_selected": map_selected
	}
	return dict 

static func from_dict(dict) -> Settings:
	if not dict.has("map_selected"): 
		dict["map_selected"] = Globals.MapChoice.THE_FARM
	
	return Settings.new( 
		dict["window_mode"],
		dict["sfx_volume"],
		dict["music_volume"],
		dict["fps_counter"],
		dict["full_health_effect"],
		dict["ai_selected"],
		dict["collab_partner_selected"],
		dict["map_selected"]
	)
