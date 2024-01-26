extends UpgradeScene

var accumulated_damage := 0.0

func _ready() -> void: 
	add_to_group("dm_allegations")

func process_collab_partner_damage_received(BASE_DAMAGE: float, modified_damage: float) -> float:
	var random_f = randf()
	if random_f <= 0.001:
		modified_damage = accumulated_damage
	else:
		accumulated_damage += modified_damage
		modified_damage = 0.0
	return modified_damage 
