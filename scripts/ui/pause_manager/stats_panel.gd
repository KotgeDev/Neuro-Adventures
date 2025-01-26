extends Control
class_name StatsPanel

signal selected(panel: StatsPanel)

@export var id: int

func _ready() -> void:
	$Button.pressed.connect(_on_selection_button_pressed)
	connect_signals()

## Override to use. For extra signal connections
func connect_signals() -> void:
	pass

## Override to use. Will run every time StatsMenu is made visible.
func setup() -> void:
	pass

## Override to use. Will run every time StatsMenu is closed
func close() -> void:
	pass

func _on_selection_button_pressed():
	selected.emit(self)
