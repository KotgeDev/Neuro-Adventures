extends UpgradeScene

func _ready():
	add_to_group("process_collab_partner_damage_received")

func process_collab_partner_damage_received(BASE_DAMAGE: float, modified_damage: float) -> float:
	match upgrade.lvl: 
		1:
			modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 10)
		2:
			modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 15)
		3:
			modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 20)
		4:
			modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 25)
		5:
			modified_damage = get_copy_paste_damage(BASE_DAMAGE, modified_damage, 40)

	return modified_damage   

func get_copy_paste_damage(BASE_DAMAGE: float, modified_damage: float, percent_chance) -> float:
	var random_int = randi_range(1, 100)
	
	if random_int <= percent_chance: 
		modified_damage = modified_damage + BASE_DAMAGE 
	
	return modified_damage 

