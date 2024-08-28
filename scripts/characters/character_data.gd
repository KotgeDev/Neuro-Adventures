extends Node
class_name CharacterData 

var character_name: String 
var hp: float 
var speed: float 
var desc: String 
var db: Array
var is_ai: bool 
var icon_outline: Texture2D

func _init(_character_name: String, _db: Array, _hp: float, _speed: float, _is_ai: bool, _icon_outline: Texture2D, _desc := "") -> void:
	character_name = _character_name
	db = _db
	hp = _hp 
	speed = _speed 
	is_ai = _is_ai 
	desc = _desc
	icon_outline = _icon_outline
