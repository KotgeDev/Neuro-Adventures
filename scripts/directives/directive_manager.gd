extends Node2D
class_name DirectiveManager

@onready var directive_resources = preload("res://resources/directives/directive_db.tres").db

var directives_db := []
var owned_directives := []

static func generate_card (
	directive: Directive,
	template: Control,
	h_container: Control,
) -> Control:
	var card_duplicate = template.duplicate()
	var card_node = card_duplicate.get_node("Card")

	var button = card_node.get_node("Button")
	var contents = card_node.get_node("Contents")
	var texture = card_node.get_node("Texture") as TextureRect

	var title = contents.get_node("Title") as Label
	var desc = contents.get_node("Description") as RichTextLabel
	var quote = contents.get_node("Quote") as Label

	texture.texture = Globals.tier_to_texture[directive.resource.tier]
	title.text = directive.resource.directive_name
	desc.text = "Effect:\n%s" % directive.resource.description
	quote.text = directive.resource.quote

	card_duplicate.visible = true
	h_container.add_child(card_duplicate)

	return card_duplicate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_directive_objects()
	Globals.request_random_directives.connect(_on_request_random_directives)
	Globals.add_directive.connect(_on_add_directive)
	Globals.remove_directive.connect(_on_remove_directive)

func _on_request_random_directives(special: bool, reroll: bool) -> void:
	Globals.show_directive_choices.emit(select_random(3, special), special, reroll)

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

func select_random(count: int, special_only: bool) -> Array:
	var results = []
	var pool = generate_pool(special_only)

	pool.shuffle()

	for i in range(count):
		results.append(find_directive(pool[0]))
		pool = pool.filter(func (x): return x != pool[0])

		if pool.size() < 1:
			return results

	return results

func generate_directive_objects() -> void:
	for dir_resource in directive_resources:
		directives_db.append(Directive.new(dir_resource))

func generate_pool(special_only := false) -> Array:
	var pool = []

	for d in directives_db:
		var directive = d as Directive
		if !directive.scene:  # If this directive is not owned
			if !special_only or directive.resource.tier == 4:
				for i in range(directive.resource.weight):
					pool.append(directive.resource.id)

	return pool

func find_directive(id: int) -> Directive:
	for d in directives_db:
		var directive = d as Directive
		if directive.resource.id == id:
			return directive

	printerr("No directive with id %d exists!" % id)
	return null
