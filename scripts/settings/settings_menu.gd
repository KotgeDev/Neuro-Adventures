extends CloseablePanel

func _on_close_button_pressed():
	close()

func close():
	visible = false
	close_panel.emit()
	SettingsManager.save_settings.emit()
