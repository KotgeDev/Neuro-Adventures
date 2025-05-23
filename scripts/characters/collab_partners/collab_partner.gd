## Parent class for all collab partners
extends CharacterBody2D
class_name CollabPartner

#region CONSTANTS
@export var BASE_MAX_SPEED := 65.0
@export var BASE_MAX_HEALTH := 40.0
@export var BASE_PICKUP_RANGE := 35.0
@export var BASE_EVASION := 0.0
const ACCELERATION := 500.0
const FRICTION := 500.0
#endregion

#region NODES
@onready var character_animation = $CharacterAnimation
#endregion

#region VALUES
@onready var max_speed: float = BASE_MAX_SPEED :
	set(value):
		max_speed = value
		StatsManager.collab_max_speed_changed.emit()
@onready var max_health: float = BASE_MAX_HEALTH
@onready var health: float = max_health
@onready var pickup_range: float = BASE_PICKUP_RANGE
var damaged_atleast_once := false

#region LEVEL
signal lvl_updated

const EXP_REQ_INCREMENT := 4
const EXP_REQ_INIT := 2

var expp := 0
var exp_requirement := EXP_REQ_INIT
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

func connect_signals() -> void:
	Globals.damage_collab_partner.connect(_on_hurtbox_take_damage)
	Globals.add_upgrade_to_collab_partner.connect(_on_add_upgrade)
	Globals.collect_exp.connect(_on_collect_exp)
	StatsManager.increase_max_hp.connect(_on_increase_max_hp)
	StatsManager.increase_speed.connect(_on_increase_speed)
	StatsManager.increase_collection_range.connect(_on_increase_cr)
	StatsManager.exp_passive_changed.connect(_on_exp_passive_changed)
	extended_signals()

func _on_increase_max_hp(inc_perc) -> void:
	max_health = BASE_MAX_HEALTH + BASE_MAX_HEALTH * inc_perc
	Globals.update_collab_partner_health.emit(max_health, health, false)

func _on_increase_speed(inc_perc) -> void:
	max_speed = BASE_MAX_SPEED + BASE_MAX_SPEED * inc_perc

func _on_increase_cr(inc_perc) -> void:
	pickup_range = BASE_PICKUP_RANGE * (1 + inc_perc)

## Override function for use in specific collab partners
func extended_signals() -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()

func _on_hurtbox_take_damage(damage: float):
	if StatsManager.collab_invincible:
		return

	if randf() < (StatsManager.evasion + StatsManager.collab_evasion):
		character_animation.show_evasion()
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
		exp_requirement = EXP_REQ_INIT + StatsManager.lvl * EXP_REQ_INCREMENT
		StatsManager.lvl += 1
		Globals.request_random_upgrades.emit()
	Globals.update_exp_bar.emit(exp_requirement, expp)

	if raise_the_timer_active:
		Globals.heal_ai.emit(per_exp_ai_hp_increase)

func _on_add_upgrade(upgrade: Node) -> void:
	add_child(upgrade)

func _on_exp_passive_changed(status: bool) -> void:
	if status:
		$ExpPassiveTimer.start(2.0)
	else:
		$ExpPassiveTimer.stop()

func _on_exp_passive_timer_timeout() -> void:
	Globals.collect_exp.emit(1)
