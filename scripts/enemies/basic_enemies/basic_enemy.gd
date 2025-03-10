## Steps to create a new Basic Enemy:
## 1. Create a new inherited scene using the BasicEnemy scene
## 2. Set Sprite2D and create an AnimationPlayer with an animation named idle
## 3. Configure Hurtbox and ContinuousHitbox CollisionShapes
extends Enemy
class_name BasicEnemy

#region CONSTANTS
@onready var AVOIDANCE_RADIUS := stats.av_radius
#endregion

#region NODES
@onready var sprite_2d = $Sprite2D
@onready var stun_effect = $StunEffect
@onready var navigation_agent = $NavPosition/NavigationAgent2D
@onready var pathfind_timer = $PathfindTimer
@onready var effect_player = $EffectPlayer
@onready var dmg_label = $DmgLabel
#endregion

#region TEMPLATES
var expp_template = preload("res://scenes/collectibles/exp.tscn")
var ntx_template = preload("res://scenes/interactive_objects/ntx_4090.tscn")
#endregion

#region OTHER
var velocity: Vector2
var next_pos: Vector2
var dead := false
var last_enemy := false
var last_flip_time: float
var stunned := false
var slow := 0.0
#endregion

#region MARCH
var march := false
var march_direction: Vector2
#endregion

func ready() -> void:
	dmg_label.modulate.a = 0
	$ContinuousHitbox.damage = damage
	$ContinuousHitbox/HitTimer.wait_time = ATTACK_INTERVAL
	$AnimationPlayer.play("idle")
	$StunEffect.visible = false

	if march:
		return
	else:
		navigation_agent.velocity_computed.connect(_on_velocity_computed)
		navigation_agent.max_speed = BASE_MAX_SPEED + 10
		navigation_agent.radius = AVOIDANCE_RADIUS
		pathfind_timer.wait_time = 0.5
		pathfind_timer.start()
		make_path()

func make_path() -> void:
	navigation_agent.target_position = target.global_position
	next_pos = navigation_agent.get_next_path_position()

func _physics_process(delta):
	if stunned:
		return

	if march:
		velocity = march_direction * max_speed * (1-slow)
		position += velocity * delta
	else:
		var dir = to_local(next_pos).normalized()
		velocity = dir * max_speed * (1-slow)
		navigation_agent.set_velocity(velocity)

	set_flip(delta)

func _on_velocity_computed(velocity: Vector2) -> void:
	if stunned:
		return

	position += velocity * get_physics_process_delta_time()

func set_flip(delta) -> void:
	if last_flip_time > 0:
		last_flip_time -= delta
	else:
		sprite_2d.flip_h = velocity.x < 0
		stun_effect.flip_h = velocity.x < 0
		last_flip_time = 0.5

func show_dmg_label(dmg) -> void:
	if dmg < 1:
		return
	elif dmg <= 5:
		dmg_label.add_theme_font_size_override("font_size", 10)
	elif dmg <= 10:
		dmg_label.add_theme_font_size_override("font_size", 12)
		modulate = Color("f72c75")
	else:
		dmg_label.add_theme_font_size_override("font_size", 16)
		modulate = Color("f72c75")

	dmg_label.text = "%.0f" % dmg
	await get_tree().create_tween().tween_property(dmg_label, "modulate:a", 1.0, 0.3).finished
	get_tree().create_tween().tween_property(dmg_label, "modulate:a", 0, 1.2)

func _on_hurtbox_take_damage(damage):
	if damage == 0:
		return

	show_dmg_label(damage)
	health -= damage

	sprite_2d.material.set_shader_parameter("white", true)
	await get_tree().create_timer(Globals.FLASH_TIME, false).timeout
	sprite_2d.material.set_shader_parameter("white", false)

	if health <= 0 and not dead:
		dead = true

		var already_dropped_item := false

		for generator in map.collectible_generators:
			var random_number = randf()
			if random_number <= generator.drop_chance:
				var collectible = generator.collectible_scene.instantiate()
				collectible.global_position = global_position
				map.call_deferred("add_child", collectible)
				already_dropped_item = true

		if not already_dropped_item:
			var expp = expp_template.instantiate()
			expp.global_position = global_position
			map.call_deferred("add_child", expp)

		var ntx_num = randf_range(0, 100)
		if map.enemies_killed_since_last_ntx < map.NTX_REQ:
			map.enemies_killed_since_last_ntx += 1
		elif map.NTX_REQ <= map.enemies_killed_since_last_ntx && map.enemies_killed_since_last_ntx < map.PITY_REQ:
			if ntx_num <= map.ntx_chance:
				spawn_ntx_4090()
			else:
				map.ntx_chance = map.BASE_NTX_CHANCE
				map.enemies_killed_since_last_ntx += 1
		elif map.PITY_REQ <= map.enemies_killed_since_last_ntx:
			if ntx_num <= map.ntx_chance:
				spawn_ntx_4090()
			else:
				map.ntx_chance += map.PITY_STEP
				map.enemies_killed_since_last_ntx += 1

		Globals.enemy_killed.emit(EXP)
		queue_free()

func spawn_ntx_4090() -> void:
	map.ntx_chance = map.BASE_NTX_CHANCE
	map.enemies_killed_since_last_ntx = 0

	var ntx = ntx_template.instantiate()
	ntx.global_position = global_position
	map.call_deferred("add_child", ntx)

func stun(stun_time: float) -> void:
	stun_effect.visible = true
	$AnimationPlayer.stop()
	effect_player.play("stunned")
	stunned = true
	await get_tree().create_timer(stun_time, false).timeout
	stunned = false
	stun_effect.visible = false
	$AnimationPlayer.play("idle")
	effect_player.stop()
