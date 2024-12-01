extends CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	button_pressed = SettingsManager.settings.full_health_effect
	toggled.connect(_on_toggled)

func _on_toggled(toggled_on: bool) -> void:
	SettingsManager.settings.full_health_effect = toggled_on 
