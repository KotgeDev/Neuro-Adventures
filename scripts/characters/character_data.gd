extends Node
class_name CharacterData 

var character_name: String 
var hp: float 
var speed: float 
var desc: String 
var db: Array
var is_ai: bool 

func _init(_character_name: String, _db: Array, _hp: float, _speed: float, _is_ai: bool, _desc := "") -> void:
	character_name = _character_name
	db = _db
	hp = _hp 
	speed = _speed 
	is_ai = _is_ai 
	desc = _desc
	
