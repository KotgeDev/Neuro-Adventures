extends OptionButton

func _ready() -> void:
	item_selected.connect(_on_window_mode_selected)
	selected = SavedOptions.settings.window_mode

func _on_window_mode_selected(index):
	SavedOptions.set_window_mode(index)
	SavedOptions.settings.window_mode = index			
