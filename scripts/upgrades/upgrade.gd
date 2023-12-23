extends Node 
class_name Upgrade

var upgrade_name: String 
var descriptions: PackedStringArray 
var upgrade_type: Globals.UpgradeType 
var max_lvl: int 
var lvl: int 
var scene_template: PackedScene
var scene: Node 

func _init(
	p_name: String, 
	p_des: PackedStringArray, 
	p_type: Globals.UpgradeType, 
	p_max: int, 
	p_lvl: int, 
	p_scene_template: PackedScene = null
) -> void: 
	upgrade_name = p_name 
	descriptions = p_des 
	upgrade_type = p_type 
	max_lvl = p_max 
	lvl = p_lvl
	scene_template = p_scene_template
