extends Node2D
class_name DirectiveManager

const DIR_PATH = "res://resources/directives"

var directives_db := []
var owned_directives := []
var tier_colors = ["9cdb43", "20d6c7", "e86a73"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_directives()
	Globals.request_random_directives.connect(_on_request_random_directives)
	Globals.add_directive.connect(_on_add_directive)
	Globals.remove_directive.connect(_on_remove_directive)

func _on_request_random_directives() -> void:
	Globals.send_random_directives.emit(select_random(4))

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

func load_directives() -> void:
	var filenames = DirAccess.get_files_at(DIR_PATH)

	for filename in filenames:
		var full_path = DIR_PATH + "/" + filename
		var resource = load(full_path)
		directives_db.append(Directive.new(resource))

func generate_pool() -> Array:
	var pool = []

	for d in directives_db:
		var directive = d as Directive
		if directive.scene:
			for map in directive.resource.increase_chances_of:
				for i in range(map.multiplier):
					pool.append(map.target_index)
		else:
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
