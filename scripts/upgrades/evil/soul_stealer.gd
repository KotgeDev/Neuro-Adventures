extends UpgradeScene

var percentage: float

func _ready():
	Globals.ai_attack.connect(_on_attack)

func _on_attack(final_damage: float) -> void:
	Globals.heal_ai.emit(final_damage * percentage)

func get_data() -> String:
	var data = (
		get_perc_str("Damage to HP", percentage)
	)
	return data

func sync_level() -> void:
	match upgrade.lvl:
		1:
			percentage = 0.005
		2:
			percentage = 0.01
		3:
			percentage = 0.015
		4:
			percentage = 0.02
