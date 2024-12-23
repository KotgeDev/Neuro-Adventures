## Parent class for all ai
extends Node2D
class_name AI 

#region BASE VALUES 
@export var BASE_MAX_SPEED := 60 
@export var ACCELERATION := 500
@export var FRICTION := 500 
@export var BASE_MAX_HEALTH := 45.0
@export var COOKIE_HEALTH := 5.0 
@export var BASE_AI_DISTANCE := 65.0 
@export var BASE_EVASION := 0.0 
#endregion 

#region NODES
@onready var character_animation = $CharacterAnimation
var collab_partner: CollabPartner
@onready var navigation_agent = $NavigationAgent2D
#endregion

#region STATS  
@onready var max_health: float = BASE_MAX_HEALTH
@onready var health: float = BASE_MAX_HEALTH 
@onready var max_speed: float = BASE_MAX_SPEED
@onready var ai_distance: float = BASE_AI_DISTANCE
@onready var evasion: float = BASE_EVASION 
#endregion 

#region OTHER 
var velocity: Vector2 
#endregion 

#region SOUNDFX
var hit_sfx: AudioStream = preload("res://assets/sfx/playerhurt.wav")
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

func _on_increase_max_hp(inc_perc) -> void:
	max_health = BASE_MAX_HEALTH + BASE_MAX_HEALTH * inc_perc 

func _on_increase_speed(inc_perc) -> void:
	max_speed += BASE_MAX_SPEED + BASE_MAX_SPEED * inc_perc 


func _on_map_ready() -> void:
	collab_partner = get_tree().get_first_node_in_group("collab_partner")
	set_physics_process(true)

func make_path() -> void: 
	navigation_agent.target_position = collab_partner.global_position

func _physics_process(delta: float) -> void:
	var distance = abs((collab_partner.global_position - self.global_position).length())
	if distance >= ai_distance:
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = velocity.move_toward(dir * max_speed, ACCELERATION * delta)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
	
	position += velocity * delta 

func _on_hurtbox_take_damage(damage: float, shake := true):
	if StatsManager.ai_invincible: 
		return 
		
	if randf() < (StatsManager.evasion + StatsManager.ai_evasion): 
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
