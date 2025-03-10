extends UpgradeScene

@onready var vedal = get_tree().get_first_node_in_group("collab_partner")
@onready var cooldown_timer = $CooldownTimer as CollabCooldownTimer
@onready var animation_player = $AnimationPlayer

@export var LV1_DURATION := 0.3
@export var LV3_DURATION := 0.6

@export var LV1_COOLDOWN := 5.0
@export var LV2_COOLDOWN := 4.0
@export var LV4_COOLDOWN := 3.0
@export var LV5_COOLDOWN := 2.0

var available := false
var duration := 0.0

func get_data() -> String:
	var data = (
		get_cd_str(cooldown_timer.base_cooldown) + "\n" +
		get_time_str("Duration", duration)
	)
	return data

func set_data(_duration: float, _cooldown: float) -> void:
	if _duration: duration = _duration
	if _cooldown: cooldown_timer.base_cooldown = _cooldown

func _ready() -> void:
	cooldown_timer.start()
	animation_player.play("loading")

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_data(0.6, 5.0)
		2:
			set_data(0.0, 4.0)
		3:
			set_data(0.8, 0.0)
		4:
			set_data(0.0, 3.0)
		5:
			set_data(1.2, 0.0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ability") and available:
		available = false
		cooldown_timer.stop()

		vedal.modulate.a = 0.5
		StatsManager.collab_invincible = true
		await get_tree().create_timer(duration, false).timeout
		StatsManager.collab_invincible = false
		vedal.modulate.a = 1.0

		cooldown_timer.start()
		animation_player.play("loading")

func _on_cooldown_timer_timeout():
	available = true
	animation_player.play("ready")
