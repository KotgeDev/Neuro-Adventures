extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready():
	button_pressed = SettingsManager.settings.fps_counter
	toggled.connect(_on_toggled)

func _on_toggled(toggled_on: bool) -> void:
	SettingsManager.settings.fps_counter = toggled_on 
	Globals.change_fps_counter_state.emit(toggled_on)
