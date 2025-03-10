extends UpgradeScene

@onready var aoe = $AOE

@export var LV1_SLOW := 0.60
@export var LV2_SLOW := 0.55
@export var LV3_SLOW := 0.50
@export var LV4_RANGE_MULTIPLIER := 1.25
@export var LV5_SLOW := 0.40

var slow: float

func get_data() -> String:
	var data = (
		get_perc_str("Slow", slow)
	)
	return data


func _ready() -> void:
	$AnimationPlayer.play("spin")

func sync_level() -> void:
	match upgrade.lvl:
		1:
			slow = 0.3
		2:
			slow = 0.35
		3:
			slow = 0.4
		4:
			slow = 0.5
		5:
			aoe.scale *= 1.25
			$OuterCircle.visible = true

func _on_aoe_area_entered(area):
	var ememy = area.get_parent()
	if ememy is BasicEnemy:
		ememy.slow = slow

func _on_aoe_area_exited(area):
	if is_instance_valid(area) and area:
		var ememy = area.get_parent()
		if ememy is BasicEnemy:
			ememy.slow = 0
