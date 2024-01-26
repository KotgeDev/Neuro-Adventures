extends OptionButton

func _ready() -> void:
	item_selected.connect(_on_vsync_mode_selected)
	selected = SavedOptions.settings.vsync_mode

func _on_vsync_mode_selected(index):
	DisplayServer.window_set_vsync_mode(index)
	SavedOptions.settings.vsync_mode = index			
