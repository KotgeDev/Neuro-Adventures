extends CloseablePanel

func _on_close_button_pressed():
	close() 

func close():
	visible = false 
	close_panel.emit() 
	SavedOptions.save_settings.emit() 
