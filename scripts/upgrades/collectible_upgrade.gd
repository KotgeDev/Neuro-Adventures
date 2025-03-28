extends UpgradeScene

@export_category("Collectible")
@export var collectible_name: String
@export var collectible_scene: PackedScene

@export_category("Lvls")
@export var lv1_chance = 0.01
@export var lv2_chance = 0.02
@export var lv3_chance = 0.03
@export var lv4_chance = 0.05

var collectible_generator: CollectibleGenerator

func get_data() -> String:
	return (
		get_perc_str("Drop chance", collectible_generator.drop_chance)
	)

func _ready() -> void:
	collectible_generator = CollectibleGenerator.new(collectible_name, lv1_chance, collectible_scene)
	Globals.add_collectible_generator.emit(collectible_generator)

func sync_level() -> void:
	match upgrade.lvl:
		1:
			collectible_generator.drop_chance = lv1_chance
		2:
			collectible_generator.drop_chance = lv2_chance
		3:
			collectible_generator.drop_chance = lv3_chance
		4:
			collectible_generator.drop_chance = lv4_chance
