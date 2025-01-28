extends UpgradeScene

var dual_strike_template = preload("res://scenes/projectiles/dual_strike.tscn")
var dual_strike_large_template = preload("res://scenes/projectiles/dual_strike_large.tscn")

#region CONSTANTS
@export_category("Dual Strike")
@export var LV1_DAMAGE := 1
@export var LV3_DAMAGE := 3
@export var LV1_WAIT_TIME := 1.5
@export var LV2_WAIT_TIME := 1
@export var LV5_WAIT_TIME := 0.7
#endregion

#region NODES
@onready var map = get_tree().get_first_node_in_group("map") as MAP
@onready var ai = get_tree().get_first_node_in_group("ai")
@onready var strikes = $Strikes
@onready var strike_1 = %Strike1
@onready var strike_2 = %Strike2
@onready var fire_timer = $FireTimer
#endregion

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/sword_swish.wav")
#endregion

var large := false
@onready var damage = LV1_DAMAGE

func _on_fire_timer_timeout():
	strikes.look_at(get_global_mouse_position())

	strike(1, true)
	await get_tree().create_timer(0.2, false).timeout
	strike(2, false)

func strike(pos: int, flip: bool) -> void:
	var strike_pos = strike_1 if pos == 1 else strike_2
	var dual_strike = dual_strike_template.instantiate() if not large else dual_strike_large_template.instantiate()
	dual_strike.position = strike_pos.global_position
	dual_strike.rotation = strike_pos.global_rotation
	dual_strike.setup(damage, flip)
	map.add_child(dual_strike)
	AudioSystem.play_sfx(hit_sfx, ai.global_position, 0.4)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			fire_timer.base_cooldown = LV1_WAIT_TIME
		2:
			fire_timer.base_cooldown = LV2_WAIT_TIME
		3:
			damage = LV3_DAMAGE
		4:
			large = true
		5:
			strike_1.position += Vector2(5, -5)
			strike_2.position += Vector2(5, 5)
			fire_timer.base_cooldown = LV5_WAIT_TIME
			map.dual_strike_max = true
