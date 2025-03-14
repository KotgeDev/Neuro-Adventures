extends Control

const MAX_DIRECTIVES = 5

@export var pause_manager: PauseManager

@onready var h_container: HBoxContainer = %HBoxContainer
@onready var directive_card: VBoxContainer = $DirectiveCard
@onready var reroll_button: Button = %RerollButton
var directive_manager: DirectiveManager

var special: bool

func _ready() -> void:
	Globals.show_directive_choices.connect(_on_show_directive_choices)
	Globals.map_ready.connect(_on_map_ready)

func _on_map_ready() -> void:
	directive_manager = get_tree().get_first_node_in_group(Globals.DIR_MANAGER_GROUP_NAME)

func _on_show_directive_choices(directives: Array, _special: bool, _reroll: bool) -> void:
	for child in h_container.get_children():
		child.queue_free()

	special = _special

	if _reroll: reroll_button.visible = true
	else: reroll_button.visible = false

	visible = true
	pause_manager.pause_game()

	var cards = []

	for i in range(3):
		var card_duplicate = DirectiveManager.generate_card(directives[i], directive_card, h_container)
		var button = card_duplicate.get_node("Card").get_node("Button")
		button.pressed.connect(_on_directive_selected.bind(directives[i]))
		cards.append(card_duplicate)

	for card in cards:
		card.play_anim()
		await get_tree().create_timer(0.25).timeout

func _on_directive_selected(directive: Directive) -> void:
	if directive_manager.owned_directives.size() == MAX_DIRECTIVES:
		Notice.create_notice(self, "You cannot have more then %d directives! \n" % MAX_DIRECTIVES +
			"You can discard existing directives from Pause -> Stats")
		return

	visible = false
	pause_manager.unpause_game()

	Globals.add_directive.emit(directive)

func _on_cancel_button_pressed() -> void:
	visible = false
	pause_manager.unpause_game()

func _on_reroll_button_pressed() -> void:
	Globals.request_random_directives.emit(special, false)
