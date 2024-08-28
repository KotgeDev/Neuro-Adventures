extends Resource
class_name UpgradeResource 

enum Tag {
	OFFENSIVE,
	PASSIVE
}

enum UpgradeType {
	AI_UPGRADE,
	COLLAB_PARTNER_UPGRADE,
}

@export var upgrade_name: String 
@export var icon: Texture2D
@export var descriptions: PackedStringArray 
@export var upgrade_type: UpgradeType 
@export var character: Globals.CharacterChoice
@export var max_lvl: int 
@export var scene_template: PackedScene
@export var unlimited := false 
@export var tag: Tag 
