extends UpgradeScene

var star_template = preload("res://scenes/projectiles/star.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var stars = $Stars

@export_category("Star")
@export var LV1_INTERVAL := 2.5
@export var LV1_DAMAGE := 2.0
@export var LV1_CHARGE_TIMER := 10.0
@export var LV2_INTERVAL = 2.0
@export var LV3_DAMAGE := 3.0
@export var LV4_INTERVAL := 1.5
@export var LV5_CHARGE_TIMER := 5.0
@export var LV6_DAMAGE := 4.0

var damage := LV1_DAMAGE
var enemy_count := 0
var charge_time := LV1_CHARGE_TIMER
var angle := 0

func get_data() -> String:
	var data = (
		get_atk_str(damage) + "\n" +
		get_cd_str(spawn_timer.base_cooldown) + "\n" +
		get_atk_str(damage*2.0, "Charged ATK") + "\n" +
		get_cd_str(charge_time, "Charge time")
	)
	return data

func set_data(_damage: float, _cooldown: float, _charge_time: float) -> void:
	if _damage: damage = _damage
	if _cooldown: spawn_timer.base_cooldown = _cooldown
	if _charge_time: charge_time = _charge_time

func sync_level() -> void:
	match upgrade.lvl:
		1:
			set_data(4.0, 2.0, 8.0)
		2:
			set_data(0.0, 1.5, 0.0)
		3:
			set_data(6.0, 0.0, 0.0)
		4:
			set_data(0.0, 0.0, 4.0)
		5:
			set_data(8.0, 0.0, 0.0)

func _on_spawn_timer_timeout():
	var star = star_template.instantiate()
	stars.add_child(star)
	star.setup(damage, charge_time, angle)
	angle += 10

func _on_area_2d_area_entered(area):
	enemy_count += 1
	Globals.update_stars.emit(true)

func _on_area_2d_area_exited(area):
	if enemy_count > 0:
		enemy_count -= 1
		if enemy_count == 0:
			Globals.update_stars.emit(false)
