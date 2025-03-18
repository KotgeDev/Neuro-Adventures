extends Resource
class_name DirectiveResource

var weight: int :
	set(value):
		assert(!weight, "Weight can only be set once")
		weight = value
@export var directive_name: String
@export var id: int
@export var tier: int :
	set(value):
		tier = value
		match tier:
			1:
				weight = 10
			2:
				weight = 5
			3:
				weight = 1
			4:
				weight = 1
@export var description: String
@export var quote: String
@export var scene_template: PackedScene
