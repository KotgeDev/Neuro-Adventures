extends Resource
class_name UpgradeResource

enum UpgradeType {
	AI_UPGRADE,
	COLLAB_PARTNER_UPGRADE,
	ENDLESS_UPGRADE,
	DRONE_UPGRADE
}

var base_weight := 1
var descriptions: PackedStringArray
var stats := {}
@export var upgrade_name: String
@export var icon: Texture2D
@export_multiline var unformated_stats: String :
	set(value):
		unformated_stats = value
		var lines = value.split('\n', false)
		for line in lines:
			var words = line.split(":")
			var numbers = words[1].split(">")
			if numbers.size() == 1:
				stats[words[0]] = [numbers[0].replace(" ", ""), numbers[0].replace(" ", "")]
			else:
				stats[words[0]] = [numbers[0].replace(" ", ""), numbers[1].replace(" ", "")]

@export_multiline var unformated_descriptions: String :
	set(value):
		unformated_descriptions = value
		descriptions = value.split('\n', false)
@export var upgrade_type: UpgradeType :
	set(value):
		upgrade_type = value
		match upgrade_type:
			UpgradeType.ENDLESS_UPGRADE:
				base_weight = 2
			_:
				base_weight = 1

@export var character: Globals.CharacterChoice
@export var max_lvl: int
@export var scene_template: PackedScene
