## Parent class for all collab partners
extends CharacterBody2D
class_name CollabPartner  

#region CONSTANTS 
@export var BASE_MAX_SPEED := 65.0 
@export var ACCELERATION := 500.0
@export var FRICTION := 500.0 
@export var BASE_MAX_HEALTH := 40.0
@export var BASE_PICKUP_RANGE := 50.0
@export var BASE_EVASION := 0.0 
#endregion 

#region NODES 
@onready var character_animation = $CharacterAnimation
@onready var collectcircle = $CollectCircle
@onready var aihp_loss_timer = $AIHPLossTimer
#endregion 

#region BASE_VALUES  
@onready var max_speed: float = BASE_MAX_SPEED
@onready var max_health: float = BASE_MAX_HEALTH
@onready var health: float = max_health
@onready var pickup_range: float = BASE_PICKUP_RANGE
@onready var evasion: float = BASE_EVASION 
#endregion 

#region OTHER
var pick_range_lerp = 0.0
var circle_occ = 0.7
var circle_work = false
var damaged_atleast_once := false 
#endregion

#region LEVEL 
const EXP_REQ_INCREMENT := 4
const EXP_REQ_INIT := 2

var expp := 0
var exp_requirement := EXP_REQ_INIT
var lv := 1 
#endregion 

#region RAISE THE TIMER
var raise_the_timer_active := false 
var per_exp_ai_hp_increase: float 
#endregion 

#region SOUNDFX
var exp_sfx: AudioStream = preload("res://assets/sfx/exp_collect.ogg")
var hit_sfx: AudioStream = preload("res://assets/sfx/playerhurt.wav")
#endregion

func _ready() -> void:
	connect_signals() 
	add_to_group(Globals.COLLAB_GROUP_NAME)
	collectcircle.texture.gradient.set_color(1, Color(collectcircle.texture.gradient.get_color(1), 0))
	collectcircle.texture.gradient.set_color(0, Color(collectcircle.texture.gradient.get_color(0), circle_occ))
	_on_powerup_get()

func connect_signals() -> void: 
	Globals.damage_collab_partner.connect(_on_hurtbox_take_damage)
	Globals.add_upgrade_to_collab_partner.connect(_on_add_upgrade)
	Globals.collect_exp.connect(_on_collect_exp)
	Globals.raise_the_timer.connect(_on_raise_the_timer)
	StatsManager.increase_max_hp.connect(_on_increase_max_hp)
	StatsManager.increase_speed.connect(_on_increase_speed)
	StatsManager.increase_collection_range.connect(_on_increase_cr)
	extended_signals() 

func _on_increase_max_hp(inc_perc) -> void:
	max_health = BASE_MAX_HEALTH + BASE_MAX_HEALTH * inc_perc 

func _on_increase_speed(inc_perc) -> void:
	max_speed = BASE_MAX_SPEED + BASE_MAX_SPEED * inc_perc 

func _on_increase_cr(inc_perc) -> void:
	pickup_range = BASE_PICKUP_RANGE + BASE_PICKUP_RANGE * inc_perc
	_on_powerup_get()

## Override function for use in specific collab partners 
func extended_signals() -> void:
	pass 

func circle_handle(delta):
	pick_range_lerp = lerp(pick_range_lerp, pickup_range*2.0, delta*5)
	collectcircle.texture.width = pick_range_lerp
	collectcircle.texture.height = pick_range_lerp
	if circle_work:
		circle_occ = lerp(circle_occ, 0.0, delta*3)
	collectcircle.texture.gradient.set_color(0, Color(collectcircle.texture.gradient.get_color(0), circle_occ))

func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	circle_handle(delta)
	if input_vector != Vector2.ZERO: 
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

func _on_hurtbox_take_damage(damage: float):
	if StatsManager.collab_invincible: 
		return 
		
	if randf() < (StatsManager.evasion + StatsManager.collab_evasion): 
		return 
	
	if damage == 0.0:
		return 
	
	health -= damage 
	damaged_atleast_once = true 
	character_animation.show_damage()
	Globals.update_collab_partner_health.emit(max_health, health)
	if health <= 0: 
		Globals.game_over.emit() 
	
	AudioSystem.play_sfx(hit_sfx, global_position, 0.8)

func _on_collect_exp(value: int) -> void:
	expp += value
	AudioSystem.play_sfx(exp_sfx, global_position, 0.4)
	if expp >= exp_requirement: 
		expp = expp - exp_requirement
		exp_requirement = EXP_REQ_INIT + lv * EXP_REQ_INCREMENT
		lv += 1
		Globals.get_random_upgrades.emit()
	Globals.update_exp_bar.emit(exp_requirement, expp) 
	
	if raise_the_timer_active:
		Globals.heal_ai.emit(per_exp_ai_hp_increase)

func _on_add_upgrade(upgrade: Node) -> void:
	add_child(upgrade)

func _on_powerup_get():
	circle_work = false
	circle_occ = 0.7
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", _on_timer_timeout.bind(timer))

func _on_timer_timeout(timer) -> void:
	circle_work = true
	timer.queue_free()

func _on_raise_the_timer(frequency: float, increase: float) -> void:
	aihp_loss_timer.wait_time = frequency 
	per_exp_ai_hp_increase = increase
	
	if not raise_the_timer_active:
		raise_the_timer_active = true 
		aihp_loss_timer.start()

func _on_aihp_loss_timer_timeout():
	Globals.damage_ai.emit(1.0, false)
