extends Control

@onready var switch_player: AnimationPlayer = $SwitchPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.switch_loading.connect(_on_switch_loading)
	Globals.switch_follow.connect(_on_switch_follow)
	Globals.switch_stop.connect(_on_switch_stop)

	switch_player.play("follow")

func _on_switch_loading() -> void:
	switch_player.play("loading")

func _on_switch_follow() -> void:
	switch_player.play("follow")

func _on_switch_stop() -> void:
	switch_player.play("stop")
