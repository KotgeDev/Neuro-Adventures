extends Node2D
class_name Enemy

@export var BASE_MAX_HEALTH := 1.0
@export var BASE_MAX_SPEED := 1.0
@export var BASE_DAMAGE := 1.0
@export var ATTACK_INTERVAL := 1.0
@export var EXP := 1.0

@onready var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME) as MAP
@onready var max_health := BASE_MAX_HEALTH
@onready var health := BASE_MAX_HEALTH
@onready var max_speed := BASE_MAX_SPEED
@onready var damage := BASE_DAMAGE

func _ready() -> void:
	add_to_group("enemy")
	set_enemy_stat_multiplier()
	ready()

func set_enemy_stat_multiplier() -> void:
	max_health = BASE_MAX_HEALTH * map.enemy_stat_mult
	health = max_health
	damage = BASE_DAMAGE * map.enemy_stat_mult

## Override to use
## _ready alternative
func ready() -> void:
	pass
