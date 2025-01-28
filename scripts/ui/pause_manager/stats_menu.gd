extends CloseablePanel

signal re_click()

@onready var v_container: VBoxContainer = %VBoxContainer

func _on_visibility_changed() -> void:
	if visible:
		for panel in v_container.get_children():
			if panel is StatsPanel:
				panel.setup()

func close() -> void:
	for panel in v_container.get_children():
		if panel is StatsPanel:
			panel.close()

	self.visible = false
	close_panel.emit()

func _on_directive_panel_reset() -> void:
	close()

	await get_tree().process_frame

	re_click.emit()

func _on_return_button_pressed() -> void:
	close()
