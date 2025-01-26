extends CloseablePanel

@onready var v_container: VBoxContainer = %VBoxContainer

func _on_visibility_changed() -> void:
	if visible:
		for panel in v_container.get_children():
			if panel is StatsPanel:
				panel.setup()

func close() -> void:
	self.visible = false
	close_panel.emit()

	for panel in v_container.get_children():
		if panel is StatsPanel:
			panel.close()
