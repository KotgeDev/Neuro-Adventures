extends UpgradeScene

@onready var collab_partner = get_tree().get_first_node_in_group("collab_partner")

var accumulated_damage := 0.0

func _ready() -> void: 
	add_to_group("dm_allegations")

## Must be the final damage received modifier 
func process_collab_partner_damage_received(BASE_DAMAGE: float, modified_damage: float) -> float:
	var random_f = randf()
	if random_f <= 0.001:
		modified_damage = accumulated_damage
	else:
		if upgrade.lvl == 1:
			accumulated_damage += modified_damage
			modified_damage *= 0.5
		elif upgrade.lvl == 2:
			accumulated_damage += modified_damage
			modified_damage *= 0.25
		elif upgrade.lvl == 3:
			accumulated_damage += modified_damage
			modified_damage = 0.0
	
	return modified_damage 
