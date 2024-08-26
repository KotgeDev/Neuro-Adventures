extends Control
class_name Notice 

@onready var timer = $Timer
@onready var label = $Label

var text: String 
var time: int 

static func create_notice(scene, text: String, time := 0.0) -> void:
	var new_notice: Notice = load("res://scenes/ui/notice.tscn").instantiate()
	
	new_notice.text = text 
	new_notice.time = time 
	
	scene.add_child.call_deferred(new_notice)

func _ready() -> void:
	get_tree().paused = true 
	
	label.text = text 
	
	if time != 0.0: 
		timer.wait_time = time 
		timer.start()
		await timer.timeout 
		close()

func _process(delta):
	if Input.is_action_just_pressed("menu"): 
		close()

func close():
	get_tree().paused = false 
	queue_free()
