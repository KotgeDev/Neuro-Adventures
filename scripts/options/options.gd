extends Control

signal close_options 

func _on_return_button_pressed():
	close_options.emit()
