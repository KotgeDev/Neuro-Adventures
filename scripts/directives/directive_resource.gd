extends Resource
class_name DirectiveResource

var multiplier: int
@export var directive_name: String
@export var id: int
@export var tier: int :
	set(value):
		tier = value
		match tier:
			1:
				multiplier = 12
			2:
				multiplier = 4
			3:
				multiplier = 1
@export var description: String
@export var quote: String
@export var increase_chances_of: Array[ChanceMap]
@export var scene_template: PackedScene
