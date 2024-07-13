extends Control

## If you emit this signal, the options menu will close and 
## any settings set will be saved. If anything else needs to be done
## when the options menu is closed, listen to this signal. 
signal close_options 

func _ready() -> void:
	close_options.connect(_on_close_options)

func _on_close_button_pressed():
	close_options.emit()

func _on_close_options():
	visible = false 
	SavedOptions.save_settings.emit() 
