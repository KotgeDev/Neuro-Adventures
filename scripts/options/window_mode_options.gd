extends OptionButton

func _ready() -> void:
	item_selected.connect(_on_window_mode_selected)
	selected = SetOptions.window_mode

func _on_window_mode_selected(index):
	match index:
		SetOptions.WindowMode.FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SetOptions.WindowMode.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SetOptions.WindowMode.BORDERLESS_WINDOW:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		SetOptions.WindowMode.BORDERLESS_FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true) 
