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
var charge_timer := LV1_CHARGE_TIMER
var angle := 0 

func sync_level() -> void:
	match upgrade.lvl:
		1:
			spawn_timer.wait_time = LV1_INTERVAL
		2:
			spawn_timer.wait_time = LV2_INTERVAL
		3:
			damage = LV3_DAMAGE
		4:
			spawn_timer.wait_time = LV4_INTERVAL
		5:
			charge_timer = LV5_CHARGE_TIMER
		6: 
			damage = LV6_DAMAGE

func _on_spawn_timer_timeout():
	var star = star_template.instantiate()
	stars.add_child(star)
	star.setup(damage, charge_timer, angle)
	angle += 10

func _on_area_2d_area_entered(area):
	enemy_count += 1 
	Globals.update_stars.emit(true)

func _on_area_2d_area_exited(area):
	if enemy_count > 0:
		enemy_count -= 1
		if enemy_count == 0: 
			Globals.update_stars.emit(false)
