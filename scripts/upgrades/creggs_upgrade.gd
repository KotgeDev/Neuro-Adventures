extends UpgradeScene

@export var lv1_chance = 0.01 
@export var lv2_chance = 0.02
@export var lv3_chance = 0.03
@export var lv4_chance = 0.05

@onready var collab_partner: CollabPartner = get_parent() 

func sync_level() -> void:
	match upgrade.lvl: 
		1:
			collab_partner.creggs_drop_chance = lv1_chance
		2:
			collab_partner.creggs_drop_chance = lv2_chance
		3:
			collab_partner.creggs_drop_chance = lv3_chance	
		4:
			collab_partner.creggs_drop_chance = lv4_chance
