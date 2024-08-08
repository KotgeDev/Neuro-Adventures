extends OptionButton

var menu_blip: AudioStream = preload("res://assets/sfx/menublip2.wav")

func _ready() -> void:
	item_selected.connect(_on_window_mode_selected)
	selected = SettingsManager.settings.window_mode
	mouse_entered.connect(_on_mouse_button_entered)

func _on_window_mode_selected(index):
	SettingsManager.set_window_mode(index)
	SettingsManager.settings.window_mode = index

func _on_mouse_button_entered():
	AudioSystem.play_sfx(menu_blip, get_viewport_rect().size / 2.0)
