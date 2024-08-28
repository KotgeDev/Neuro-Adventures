extends Node 
class_name Upgrade

var upgrade_name: String 
var icon: Texture2D
var descriptions: PackedStringArray 
var upgrade_type: UpgradeResource.UpgradeType 
var max_lvl: int 
var lvl: int 
var scene_template: PackedScene
var scene: Node 
var unlimited: bool  
var tag: UpgradeResource.Tag

func _init(
	_name: String,
	_icon: Texture2D, 
	_des: PackedStringArray, 
	_type: UpgradeResource.UpgradeType, 
	_max: int, 
	_lvl: int, 
	_scene_template: PackedScene,
	_unlimited: bool,
	_tag: UpgradeResource.Tag
) -> void: 
	upgrade_name = _name
	icon = _icon 
	descriptions = _des 
	upgrade_type = _type 
	max_lvl = _max 
	lvl = _lvl
	scene_template = _scene_template
	unlimited = _unlimited 
	tag = _tag

