extends UpgradeScene

var percentage = 1

func _ready():
	Globals.ai_attack.connect(_on_attack) 
	
func _on_attack(final_damage: float) -> void:
	Globals.heal_ai.emit(final_damage * percentage)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			percentage = 0.01
		2:
			percentage = 0.02
		3:
			percentage = 0.03
		4: 
			percentage = 0.05
