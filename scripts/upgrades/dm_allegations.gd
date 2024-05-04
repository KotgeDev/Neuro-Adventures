extends UpgradeScene

@onready var vedal = get_tree().get_first_node_in_group("collab_partner")
@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = $AnimationPlayer

@export var LV1_DURATION := 0.3
@export var LV3_DURATION := 0.6

@export var LV1_COOLDOWN := 5.0 
@export var LV2_COOLDOWN := 4.0
@export var LV4_COOLDOWN := 3.0 
@export var LV5_COOLDOWN := 2.0  

var active := false 
var available := false 
var duration := 0.0 

func _ready() -> void: 
	add_to_group("dm_allegations")
	sync_level()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ability") and available:
		available = false 
		cooldown_timer.stop() 
		
		vedal.modulate.a = 0.5 
		active = true 
		await get_tree().create_timer(duration, false).timeout
		active = false 
		vedal.modulate.a = 1.0
		
		cooldown_timer.start() 
		animation_player.play("loading")

func damage_received_modifiers_collab(BASE_DAMAGE: float, modified_damage: float) -> float:
	if active: 
		return 0 
	else:
		return modified_damage 

func sync_level() -> void:
	match upgrade.lvl:
		1:
			cooldown_timer.wait_time = LV1_COOLDOWN 
			cooldown_timer.start() 
			animation_player.play("loading")
			duration = LV1_DURATION
		2:
			cooldown_timer.wait_time = LV2_COOLDOWN
		3:
			duration = LV3_DURATION 
		4:
			cooldown_timer.wait_time = LV4_COOLDOWN
		5:
			cooldown_timer.wait_time = LV5_COOLDOWN

func _on_cooldown_timer_timeout():
	available = true 
	animation_player.play("ready")
