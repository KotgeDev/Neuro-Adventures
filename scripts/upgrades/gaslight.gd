extends UpgradeScene

func _ready() -> void: 
	add_to_group("gaslight")

func process_ai_damage_received(BASE_DAMAGE: float, modified_damage: float) -> float:
	match upgrade.lvl: 
		1:
			modified_damage = get_gaslight_damage(modified_damage, 5, 10)
		2:
			modified_damage = get_gaslight_damage(modified_damage, 10, 20) 
		3:
			modified_damage = get_gaslight_damage(modified_damage, 20, 30)
		4:   
			modified_damage = get_gaslight_damage(modified_damage, 40, 50)

	return modified_damage 

func get_gaslight_damage(damage: float, ignore_chance: int, divert_chance:int) -> float: 
	var random_int = randi_range(1, 100)
	
	if random_int <= ignore_chance: 
		damage = 0.0
	elif ignore_chance < random_int and random_int <= (ignore_chance + divert_chance):
		Globals.damage_collab_partner.emit(damage)
		damage = 0.0 
	return damage 
