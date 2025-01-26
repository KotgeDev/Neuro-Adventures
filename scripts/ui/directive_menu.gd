extends Control

@export var pause_manager: PauseManager

@onready var h_container: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var directive_card: VBoxContainer = $DirectiveCard
var directive_manager: DirectiveManager

var spare_directive: Directive

func _ready() -> void:
	Globals.send_random_directives.connect(_on_send_random_directives)
	Globals.map_ready.connect(_on_map_ready)

func _on_map_ready() -> void:
	directive_manager = get_tree().get_first_node_in_group(Globals.DIR_MANAGER_GROUP_NAME)

func _on_send_random_directives(directives: Array) -> void:
	visible = true
	pause_manager.pause_game()

	spare_directive = directives[3]

	for i in range(3):
		generate_card(directives[i])

func generate_card(directive: Directive, no_reroll := false) -> void:
	var dir_card_duplicate = directive_card.duplicate()
	var card = dir_card_duplicate.get_node("Card")
	var reroll_button = dir_card_duplicate.get_node("RerollButton")

	var button = card.get_node("Button")
	var contents = card.get_node("Contents")

	var title = contents.get_node("Title") as Label
	var rarity = contents.get_node("Rarity") as RichTextLabel
	var desc = contents.get_node("Description") as Label
	var chances = contents.get_node("Chances") as RichTextLabel
	var quote = contents.get_node("Quote") as Label

	button.pressed.connect(_on_directive_selected.bind(directive))
	if no_reroll:
		reroll_button.visible = false
	else:
		reroll_button.pressed.connect(_on_reroll_selected.bind(dir_card_duplicate))

	title.text = directive.resource.directive_name

	var tier_text = ""
	for i in range(directive.resource.tier):
		tier_text += "I"
	rarity.text = "[center][color=%s]- Tier %s -" % [directive_manager.tier_colors[directive.resource.tier-1], tier_text]
	desc.text = "Effect:\n%s" % directive.resource.description
	var chances_text = "Increases Chances Of: \n"
	for chance_map in directive.resource.increase_chances_of:
		var dir_res = directive_manager.find_directive(chance_map.target_index).resource
		var dir_name = dir_res.directive_name
		var dir_rarity = dir_res.tier
		chances_text += "[color=%s]" % directive_manager.tier_colors[directive.resource.tier-1] + dir_name + '\n'
	chances.text = chances_text
	quote.text = directive.resource.quote

	dir_card_duplicate.visible = true
	h_container.add_child(dir_card_duplicate)

func _on_directive_selected(directive: Directive) -> void:
	if directive_manager.owned_directives.size() > 7:
		Notice.create_notice(self, "You cannot have more then 7 directives! \n" +
			"You can discard existing directives from Pause Menu -> Stats")
		return

	visible = false
	pause_manager.unpause_game()

	print(directive.resource.directive_name + " selected!")
	Globals.add_directive.emit(directive)

	for child in h_container.get_children():
		child.queue_free()

func _on_reroll_selected(card_to_be_replaced: Control) -> void:
	for card in h_container.get_children():
		card.get_node("RerollButton").visible = false

	card_to_be_replaced.queue_free()
	generate_card(spare_directive, true)

func _on_cancel_button_pressed() -> void:
	visible = false
	pause_manager.unpause_game()

	for child in h_container.get_children():
		child.queue_free()
