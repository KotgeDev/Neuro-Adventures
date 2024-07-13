extends BaseButton

var menu_blip: AudioStream = preload("res://assets/sfx/menublip2.wav")

func _ready() -> void:
	mouse_entered.connect(_on_mouse_button_entered)

func _on_mouse_button_entered():
	AudioSystem.play_sfx(menu_blip, get_viewport_rect().size / 2.0)
