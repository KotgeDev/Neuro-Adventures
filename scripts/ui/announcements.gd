extends CloseablePanel

@onready var devlogs = preload("res://resources/devlogs/devlogs.tres").db
@onready var container = %VBoxContainer
@onready var dev_log = $DevLog

# Called when the node enters the scene tree for the first time.
func _ready():
	for log in devlogs:
		var log_name = "v%s %s Update" % [log.version, log.title]
		add_log(log_name, log.devlog)

func add_log(p_log_name: String, p_text: String) -> void:
	var dev_log = dev_log.duplicate()
	var log_name = dev_log.get_node("LogName")
	var text = dev_log.get_node("Text")

	log_name.text = p_log_name
	text.text = p_text

	dev_log.visible = true
	container.add_child(dev_log)

func _on_close_button_pressed():
	close()
