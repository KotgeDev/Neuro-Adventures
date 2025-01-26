## Parent class for all ai
extends Node2D
class_name AI

#region BASE VALUES
@export var BASE_MAX_SPEED := 60
@export var BASE_MAX_HEALTH := 45.0
@export var COOKIE_HEALTH := 5.0
@export var BASE_AI_DISTANCE := 65.0
@export var BASE_EVASION := 0.0
const ACCELERATION := 400
const FRICTION := 400
#endregion

#region NODES
@onready var character_animation = $CharacterAnimation
var collab_partner: CollabPartner
@onready var navigation_agent = $NavigationAgent2D
@onready var switch_timer: Timer = $SwitchTimer
#endregion

#region STATS
@onready var max_health: float = BASE_MAX_HEALTH
@onready var health: float = BASE_MAX_HEALTH
@onready var max_speed: float = BASE_MAX_SPEED :
	set(value):
		max_speed = value
		StatsManager.ai_max_speed_changed.emit()
@onready var ai_distance: float = BASE_AI_DISTANCE
@onready var evasion: float = BASE_EVASION
#endregion

#region OTHER
var velocity: Vector2
var hit_sfx: AudioStream = preload("res://assets/sfx/playerhurt.wav")
#endregion

#region SWITCH
var switch_time := 1.0
var switch_loading := false
var follow := true
var stop_lag_timer := 0.0
#endregion

func _ready() -> void:
	add_to_group(Globals.AI_GROUP_NAME)
	connect_signals()
	set_physics_process(false)

func connect_signals() -> void:
	Globals.map_ready.connect(_on_map_ready)
	Globals.damage_ai.connect(_on_hurtbox_take_damage)
	Globals.heal_ai.connect(_on_increase_hp)
	Globals.add_upgrade_to_ai.connect(_on_add_upgrade)
	Globals.collect_cookie.connect(_on_collect_cookie)
	StatsManager.increase_max_hp.connect(_on_increase_max_hp)
	StatsManager.increase_speed.connect(_on_increase_speed)

func _on_map_ready() -> void:
	collab_partner = get_tree().get_first_node_in_group("collab_partner")
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var distance = abs((collab_partner.global_position - self.global_position).length())

	if follow:
		if distance > ai_distance:
			stop_lag_timer = 0.2
			follow_collab(delta)
		else:
			if stop_lag_timer <= 0.0:
				stop_moving(delta)
			else:
				stop_lag_timer -= delta
				follow_collab(delta)
	else:
		stop_moving(delta)

	position += velocity * delta

func stop_moving(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func follow_collab(delta: float) -> void:
	var dir = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = velocity.move_toward(dir * max_speed, ACCELERATION * delta)

func _process(delta: float) -> void:
	if not switch_loading and Input.is_action_just_pressed("switch"):
		switch_timer.wait_time = switch_time * (1.0 - StatsManager.switch_time_dec_pct)
		switch_timer.start()
		switch_loading = true
		Globals.switch_loading.emit()
		follow = !follow

func _on_switch_timer_timeout() -> void:
	switch_timer.stop()
	if follow:
		Globals.switch_follow.emit()
	else:
		Globals.switch_stop.emit()
	switch_loading = false

func make_path() -> void:
	navigation_agent.target_position = collab_partner.global_position

func _on_increase_max_hp(inc_perc) -> void:
	max_health = BASE_MAX_HEALTH + BASE_MAX_HEALTH * inc_perc

func _on_increase_speed(inc_perc) -> void:
	max_speed = BASE_MAX_SPEED + BASE_MAX_SPEED * inc_perc

func _on_hurtbox_take_damage(damage: float, shake := true):
	if StatsManager.ai_invincible:
		return

	if randf() < (StatsManager.evasion + StatsManager.ai_evasion):
		character_animation.show_evasion()
		return

	if damage == 0.0:
		return

	health -= damage
	character_animation.show_damage()
	Globals.update_ai_health.emit(max_health, health, shake)
	if health <= 0:
		Globals.game_over.emit()

	AudioSystem.play_sfx(hit_sfx, global_position)

func _on_add_upgrade(upgrade: Node) -> void:
	add_child(upgrade)

func _on_collect_cookie() -> void:
	health += COOKIE_HEALTH

	if health >= max_health:
		health = max_health

	Globals.update_ai_health.emit(max_health, health, false)

func _on_increase_hp(increase_amount: float) -> void:
	health += increase_amount

	if health >= max_health:
		health = max_health

	Globals.update_ai_health.emit(max_health, health, false)

func _on_path_find_timer_timeout():
	make_path()
