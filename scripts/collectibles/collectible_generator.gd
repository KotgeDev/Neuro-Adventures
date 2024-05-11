extends Node
class_name CollectibleGenerator

var collectible_name: String 
var drop_chance: float
var collectible_scene: PackedScene
 
func _init(p_collectible_name, p_drop_chance, p_collectible_scene) -> void:
	collectible_name = p_collectible_name
	drop_chance = p_drop_chance 
	collectible_scene = p_collectible_scene
