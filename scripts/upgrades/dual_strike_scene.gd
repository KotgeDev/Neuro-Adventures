extends UpgradeScene

var dual_strike_template = preload("res://scenes/projectiles/dual_strike.tscn")
var dual_strike_large_template = preload("res://scenes/projectiles/dual_strike_large.tscn")

#region CONSTANTS
@export_category("Dual Strike")
@export var LV1_DAMAGE := 2 
@export var LV3_DAMAGE := 4
@export var LV1_WAIT_TIME := 1.5
@export var LV2_WAIT_TIME := 1
@export var LV5_WAIT_TIME := 0.5
#endregion 

#region NODES
@onready var map = get_parent().get_parent()
@onready var strikes = $Strikes
@onready var strike_1 = %Strike1
@onready var strike_2 = %Strike2
@onready var fire_timer = $FireTimer
#endregion

var large := false 
@onready var damage = LV1_DAMAGE 

func _ready() -> void:
	sync_level() 
	fire_timer.wait_time = LV1_WAIT_TIME 

func _on_fire_timer_timeout():
	strikes.look_at(get_global_mouse_position())
	
	strike(1, true)
	await get_tree().create_timer(0.2).timeout
	strike(2, false)

func strike(pos: int, flip: bool) -> void: 
	var strike_pos = strike_1 if pos == 1 else strike_2
	var dual_strike = dual_strike_template.instantiate() if not large else dual_strike_large_template.instantiate()
	dual_strike.position = strike_pos.global_position
	dual_strike.rotation = strike_pos.global_rotation
	dual_strike.setup(damage, flip)
	map.add_child(dual_strike)

func sync_level() -> void:
	if upgrade.lvl >= 2: 
		fire_timer.wait_time = LV2_WAIT_TIME
	
	if upgrade.lvl >= 3: 
		damage = LV3_DAMAGE 
	
	if upgrade.lvl >= 4:
		large = true 
	
	if upgrade.lvl >= 5:
		strike_1.position += Vector2(5, -5)
		strike_2.position += Vector2(5, 5)
		fire_timer.wait_time = LV5_WAIT_TIME 
