extends Node

@export var musicFile : AudioStream
@onready var audioSystem = $"/root/Audiosystem"
# Called when the node enters the scene tree for the first time.
func _ready():
	audioSystem.play_music(musicFile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
