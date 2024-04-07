extends TextureButton

var menu_blip: AudioStream = preload("res://assets/sfx/menublip2.wav")

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	AudioSystem.play_sfx(menu_blip, get_viewport_rect().size / 2.0)
