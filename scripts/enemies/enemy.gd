extends Node2D
class_name Enemy

@export var stats: EnemyStats

@onready var BASE_MAX_HEALTH: float = stats.health[lvl-1]
@onready var BASE_MAX_SPEED: float = stats.speed[lvl-1]
@onready var BASE_DAMAGE: float = stats.damage[lvl-1]
@onready var ATTACK_INTERVAL := 1.0
@onready var EXP: float = stats.exp[lvl-1]
@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME) as MAP
@onready var collab: CollabPartner = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)
@onready var ai: AI = get_tree().get_first_node_in_group(Globals.AI_GROUP_NAME)
@onready var max_health: float
@onready var health: float
@onready var max_speed := BASE_MAX_SPEED
@onready var damage: float

var target
var lvl := 1

func _ready() -> void:
	add_to_group("enemy")
	set_enemy_stat_multiplier()

	StatsManager.insurgency_changed.connect(_on_insurgency_changed)
	if StatsManager.insurgency:
		target = collab
	else:
		target = ai

	ready()

func set_enemy_stat_multiplier() -> void:
	max_health = BASE_MAX_HEALTH * (1.0 + map.enemy_stat_inc)
	health = max_health
	damage = BASE_DAMAGE * (1.0 + map.enemy_stat_inc)
	max_speed = BASE_MAX_SPEED * (1.0 + map.enemy_stat_inc * 0.5)

func _on_insurgency_changed(value) -> void:
	if value:
		target = collab
	else:
		target = ai

## Override to use
func ready() -> void:
	pass
