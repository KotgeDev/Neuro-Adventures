extends Enemy

#region CONSTANTS
@export var ACCELERATION := 500
@export var FRICTION := 500
#endregion

#region NODES
@onready var sprite_2d = $Sprite2D
@onready var navigation_agent = $NavigationAgent2D
@onready var search_field = $SearchField
@onready var animation_player = $AnimationPlayer
@onready var fire_point = $FirePoint
@onready var pattern1_timer = $Pattern1Timer
@onready var pattern2_timer = $Pattern2Timer
@onready var healthbar = $Healthbar
#endregion

#region STATS
@onready var phase_thresholds := [max_health, max_health * 0.35]
var warning_time: float
#endregion

#region OTHER
var velocity: Vector2
var just_started_running := false
var just_started_shooting := false
#endregion

var arrow_path_template = preload("res://scenes/projectiles/arrow_path.tscn")

func ready() -> void:
	global_position = Vector2(randi_range(50, 2500), randi_range(50, 600))
	$ContinuousHitbox.damage = damage
	$ContinuousHitbox/HitTimer.wait_time = ATTACK_INTERVAL
	update_phase(1)

func update_phase(phase: int) -> void:
	match phase:
		1:
			pattern1_timer.start(2.0)
			warning_time = 1.7
		2:
			pattern1_timer.stop()

			pattern2_timer.start(3.0)
			warning_time = 1.5

func make_path() -> void:
	navigation_agent.target_position = target.global_position

func _physics_process(delta):
	if target not in search_field.get_overlapping_bodies():
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = velocity.move_toward(dir * max_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	update_animation()

	position += velocity * delta

func update_animation() -> void:
	if velocity == Vector2.ZERO:
		just_started_running = false
		if not just_started_shooting:
			animation_player.play("shooting")
			just_started_shooting = true
	else:
		just_started_shooting = false
		if not just_started_running:
			animation_player.play("running")
			just_started_running = true

	if velocity.x < 0:
		sprite_2d.flip_h = true
	elif velocity.x > 0:
		sprite_2d.flip_h = false
	elif velocity == Vector2.ZERO:
		if global_position.x > ai.global_position.x:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false

func _on_hurtbox_take_damage(dmg):
	health -= dmg
	healthbar.value = health / max_health * 100

	sprite_2d.material.set_shader_parameter("white", true)
	await get_tree().create_timer(Globals.FLASH_TIME, false).timeout
	sprite_2d.material.set_shader_parameter("white", false)

	if health <= 0:
		Globals.game_won.emit()
		Globals.enemy_killed.emit(EXP)
		queue_free()

	elif health <= phase_thresholds[1]:
		update_phase(2)

func _on_pathfind_timer_timeout():
	make_path()

func _on_pattern1_timer_timeout():
	var arrow_path = arrow_path_template.instantiate()
	arrow_path.setup(target, damage, warning_time)
	get_parent().add_child(arrow_path)

	arrow_path.global_position = fire_point.global_position
	arrow_path.look_at(target.global_position)

func _on_pattern2_timer_timeout():
	if health <= phase_thresholds[1]:
		for i in range(2):
			var fsign: float
			if i % 2 == 0:
				fsign = -1.0
			else:
				fsign = 1.0
			var arrow_path = arrow_path_template.instantiate()
			var arrow_x: float = target.global_position.x + target.global_position.y * fsign

			arrow_path.setup(target, damage, warning_time)
			get_parent().add_child(arrow_path)

			arrow_path.global_position = Vector2(arrow_x, 0.0)
			arrow_path.look_at(target.global_position)
