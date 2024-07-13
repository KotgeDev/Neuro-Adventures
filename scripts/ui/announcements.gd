extends Control

signal close_announcements

var devlogs := {
"v1.2 Devlog": """\
Anny has been added as a playable collab partner!

""",
"v1.1 Devlog": """\
Evil has been added as a playable AI!

""",
"v1.0 Devlog": """\
Neuro Adventures! v1.0 has finally been released! All of the major features that I wish to add to the game have been added at this point, however, this is not the end! I plan on continuing the development of this game, and possibly adding more characters. The two characters I have planned for now are Evil-Neuro (New AI) and Annytf (New Collab Partner). I also plan on making some alternative outfits for the characters! So stay tuned!

"""
}

@onready var container = %VBoxContainer
@onready var dev_log = $DevLog

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in devlogs:
		add_log(key, devlogs[key])

func add_log(p_log_name: String, p_text: String) -> void:
	var dev_log = dev_log.duplicate() 
	var log_name = dev_log.get_node("LogName")
	var text = dev_log.get_node("Text")
	
	log_name.text = p_log_name
	text.text = p_text
	
	dev_log.visible = true 
	container.add_child(dev_log)

func _on_close_button_pressed():
	visible = false 
	close_announcements.emit() 
