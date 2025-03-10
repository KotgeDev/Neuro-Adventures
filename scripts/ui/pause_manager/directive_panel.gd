extends StatsPanel

signal reset

@onready var directive_card: VBoxContainer = %DirectiveCard
@onready var h_container: HBoxContainer = %DirectiveHBoxContainer
@onready var discard_panel: ColorRect = %DiscardPanel
var directive_manager: DirectiveManager

var selected_directive: Directive

func setup() -> void:
	directive_manager = get_tree().get_first_node_in_group(Globals.DIR_MANAGER_GROUP_NAME)

	if visible:
		for directive in directive_manager.owned_directives:
			var card_duplicate = DirectiveManager.generate_card(directive, directive_card, h_container)
			var button = card_duplicate.get_node("Card").get_node("Button")
			button.pressed.connect(_on_directive_selected.bind(directive))

#func generate_card(directive: Directive) -> void:
	#var dir_card_duplicate = directive_card.duplicate()
	#var card = dir_card_duplicate.get_node("Card")
	#var button = card.get_node("Button")
	#var contents = card.get_node("Contents")
#
	#var title = contents.get_node("Title") as Label
	#var rarity = contents.get_node("Rarity") as RichTextLabel
	#var desc = contents.get_node("Description") as Label
	#var chances = contents.get_node("Chances") as RichTextLabel
	#var quote = contents.get_node("Quote") as Label
#
	#button.pressed.connect(_on_directive_selected.bind(directive))
#
	#title.text = directive.resource.directive_name
#
	#var tier_text = ""
	#for i in range(directive.resource.tier):
		#tier_text += "I"
	#rarity.text = "[center][color=%s]- Tier %s -" % [directive_manager.tier_colors[directive.resource.tier-1], tier_text]
	#desc.text = "Effect:\n%s" % directive.resource.description
	#var chances_text = "Increases Chances Of: \n"
	#for chance_map in directive.resource.increase_chances_of:
		#var dir_res = directive_manager.find_directive(chance_map.target_index).resource
		#var dir_name = dir_res.directive_name
		#var dir_rarity = dir_res.tier
		#chances_text += "[color=%s]" % directive_manager.tier_colors[directive.resource.tier-1] + dir_name + '\n'
	#chances.text = chances_text
	#quote.text = directive.resource.quote
#
	#dir_card_duplicate.visible = true
	#h_container.add_child(dir_card_duplicate)

func _on_directive_selected(directive: Directive) -> void:
	selected_directive = directive
	discard_panel.visible = true

func _on_yes_button_pressed() -> void:
	discard_directive(selected_directive)
	discard_panel.visible = false

	reset.emit()

func _on_no_button_pressed() -> void:
	discard_panel.visible = false

func discard_directive(directive: Directive) -> void:
	Globals.remove_directive.emit(directive)

func close() -> void:
	for child in h_container.get_children():
		child.queue_free()
