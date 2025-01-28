extends Node2D
class_name DirectiveManager

var directives_db := []
var owned_directives := []
var tier_colors = ["9cdb43", "20d6c7", "e86a73"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_directive_objects()
	Globals.request_random_directives.connect(_on_request_random_directives)
	Globals.add_directive.connect(_on_add_directive)
	Globals.remove_directive.connect(_on_remove_directive)

func _on_request_random_directives() -> void:
	Globals.show_directive_choices.emit(select_random(4))

func _on_add_directive(directive: Directive) -> void:
	if !directive.resource.scene_template:
		printerr("No scene template found for %s" % directive.resource.directive_name)
		return

	# Create scene and add as child
	directive.scene = directive.resource.scene_template.instantiate()
	add_child(directive.scene)

	owned_directives.append(directive)

func _on_remove_directive(directive: Directive) -> void:
	# Queue free and set scene to null
	directive.scene.queue_free()
	directive.scene = null

	owned_directives.erase(directive)

func select_random(count: int) -> Array:
	var results = []
	var pool = generate_pool()

	pool.shuffle()

	for i in range(count):
		results.append(find_directive(pool[i]))
		pool = pool.filter(func (x): return x != pool[i])

	return results

func generate_directive_objects() -> void:
	for dir_resource in DirectiveLoader.directive_resources:
		directives_db.append(Directive.new(dir_resource))

func generate_pool() -> Array:
	var pool = []

	for d in directives_db:
		var directive = d as Directive
		if directive.scene:  # If this directive is owned
			for map in directive.resource.increase_chances_of:
				# If a directive in the map is not owned
				if !find_directive(map.target_index).scene:
					for i in range(map.multiplier):
						pool.append(map.target_index)
		else:  # If this directive is not owned
			for i in range(directive.resource.multiplier):
				pool.append(directive.resource.id)

	return pool

func find_directive(id: int) -> Directive:
	for d in directives_db:
		var directive = d as Directive
		if directive.resource.id == id:
			return directive

	printerr("No directive with id %d exists!" % id)
	return null
