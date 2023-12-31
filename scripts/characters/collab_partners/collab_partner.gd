## Parent class for all collab partners
extends CharacterBody2D
class_name CollabPartner  

#region CONSTANTS 
@export var BASE_MAX_SPEED := 80.0 
@export var ACCELERATION := 500.0
@export var FRICTION := 500.0 
@export var MAX_HEALTH := 50.0 
@export var EXP_REQ_INCREMENT := 5
@export var EXP_REQ_INIT := 2
@export var BASE_PICKUP_RANGE := 50.0
#endregion 

#region NODES 
@onready var character_animation = $CharacterAnimation
@onready var collectionbox = $Collectionbox
@onready var collectcircle = $CollectCircle
#endregion 

#region OTHER 
@onready var max_speed: float = BASE_MAX_SPEED
@onready var health: float = MAX_HEALTH
@onready var pickup_range: float = BASE_PICKUP_RANGE
var pick_range_lerp = 0.0
var circle_occ = 0.7
var circle_work = false
var expp := 0
var exp_requirement := EXP_REQ_INIT
var lv := 1  
#endregion

#region SOUNDFX
@onready var audioSystem = $"/root/Audiosystem"
@export var exp_sfx: AudioStream
#endregion

func _ready() -> void:
	add_to_group("collab_partner")
	collectcircle.texture.gradient.set_color(1, Color(collectcircle.texture.gradient.get_color(1), 0))
	collectcircle.texture.gradient.set_color(0, Color(collectcircle.texture.gradient.get_color(0), circle_occ))
	_on_powerup_get()
	connect_signals() 

func connect_signals() -> void: 
	Globals.damage_collab_partner.connect(_on_hurtbox_take_damage)
	Globals.add_upgrade_to_collab_partner.connect(_on_add_upgrade)
	collectionbox.area_entered.connect(_on_collectionbox_area_entered)

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
	damage = process_collab_partner_damage_received(damage)
	if damage == 0.0:
		return 
	
	health -= damage 
	character_animation.show_damage()
	Globals.update_collab_partner_health.emit(MAX_HEALTH, health)
	if health <= 0: 
		Globals.game_over.emit() 

func _on_collectionbox_area_entered(area):
	expp += 1 
	#print(exp_sfx)
	audioSystem.play_sfx(exp_sfx, global_position, 0.5)
	if expp >= exp_requirement: 
		expp = 0 
		exp_requirement += EXP_REQ_INCREMENT
		lv += 1
		Globals.get_random_upgrades.emit()
	Globals.update_exp_bar.emit(exp_requirement, expp) 
	#area.queue_free() 

func process_collab_partner_damage_received(BASE_DAMAGE: float) -> float:
	var modified_damage := BASE_DAMAGE
	
	for upgrade in get_tree().get_nodes_in_group("process_collab_partner_damage_received"):
		modified_damage = upgrade.process_collab_partner_damage_received(BASE_DAMAGE, modified_damage) 

	return modified_damage

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
