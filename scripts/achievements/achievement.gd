extends Node
class_name Achievement

var title: String
var requirement: String 
var icon: Texture2D

func _init(title_p: String, requirement_p: String, icon_p: Texture2D) -> void:
	title = title_p
	requirement = requirement_p 
	icon = icon_p
