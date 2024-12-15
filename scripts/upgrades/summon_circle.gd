extends UpgradeScene

@onready var aoe = $AOE

@export var LV1_SLOW := 0.60
@export var LV2_SLOW := 0.55
@export var LV3_SLOW := 0.50
@export var LV4_RANGE_MULTIPLIER := 1.25
@export var LV5_SLOW := 0.45
@export var LV6_SLOW := 0.40

var slow_multiplier: float 

func _ready() -> void:
	$AnimationPlayer.play("spin")

func sync_level() -> void:
	match upgrade.lvl:
		1:
			slow_multiplier = LV1_SLOW
		2:
			slow_multiplier = LV2_SLOW
		3:
			slow_multiplier = LV3_SLOW
		4:
			aoe.scale *= LV4_RANGE_MULTIPLIER
			$OuterCircle.visible = true 
		5:
			slow_multiplier = LV5_SLOW
			$OuterCircle.visible = true 
		6:
			slow_multiplier = LV6_SLOW
			$OuterCircle.visible = true 
			
func _on_aoe_area_entered(area):
	var target = area.get_parent() 
	if target is CollabPartner:
		target.max_speed *= slow_multiplier
	elif target is Enemy:
		target.max_speed *= slow_multiplier 

func _on_aoe_area_exited(area):
	if is_instance_valid(area) and area:
		var target = area.get_parent() 
		if target is CollabPartner:
			target.max_speed = target.BASE_MAX_SPEED 
		if target is Enemy:
			target.max_speed = target.BASE_MAX_SPEED
	
