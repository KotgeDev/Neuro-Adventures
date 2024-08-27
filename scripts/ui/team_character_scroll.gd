extends ScrollContainer

const SCREEN_HALF_Y = 180 
const SCREEN_HALF_X = 320 
const CARD_LENGTH = 132

@onready var v_container = $VBoxContainer
@onready var timer = $Timer

@export var selected_card: CharacterCard
@export var ai_scroll := true 

var scrolling := false 
var timer_on := false 

func _ready() -> void:
	timer.wait_time = 0.2 
	timer.timeout.connect(_on_timer_timeout)
	
	await get_tree().process_frame
	set_default()
	
	for card in v_container.get_children():
		if card is CharacterCard:
			card.selected_t.connect(_on_card_selected) 

func _process(delta) -> void:
	if ai_scroll and get_global_mouse_position().x >= SCREEN_HALF_X:
		return 
	if not ai_scroll and get_global_mouse_position().x <= SCREEN_HALF_X:
		return 
		
	if Input.is_action_just_pressed("mouse_scroll") and not scrolling:
		scrolling = true 
		on_scroll_started()
	elif not Input.is_action_just_pressed("mouse_scroll") and scrolling and not timer_on:
		timer_on = true 
		timer.start()
	elif Input.is_action_just_pressed("mouse_scroll") and scrolling and timer_on:
		timer_on = false
		timer.stop() 

func _on_timer_timeout() -> void:
	on_scroll_ended()
	timer.stop() 
	timer_on = false  
	scrolling = false 

func _on_card_selected(card: CharacterCard) -> void:
	selected_card = card
	select_card()

func on_scroll_started() -> void:
	for card in v_container.get_children():
		if card is CharacterCard:
			change_card_opacity(card, 1.0)  

func on_scroll_ended() -> void:
	for card in v_container.get_children(): 
		if card is CharacterCard and card_highlighted(card):
			selected_card = card 
			select_card() 
			return 

func card_highlighted(card: CharacterCard) -> bool:
	if card.global_position.y <= SCREEN_HALF_Y and \
		SCREEN_HALF_Y <= card.global_position.y + CARD_LENGTH:
		return true 
	else:
		return false 

func select_card() -> void: 
	if ai_scroll:
		SettingsManager.settings.ai_selected = selected_card.character
	else:
		SettingsManager.settings.collab_partner_selected = selected_card.character
	
	SettingsManager.save_settings.emit()
		
	for card in v_container.get_children():
		if card is CharacterCard and card.character != selected_card.character:
			change_card_opacity(card, 0.3) 
	change_card_opacity(selected_card, 1.0) 
	
	var tween = get_tree().create_tween() 
	tween.tween_property(self, "scroll_vertical", selected_card.id * CARD_LENGTH , 0.3)

func set_default() -> void: 
	if ai_scroll:
		for card in v_container.get_children():
			if card is CharacterCard and card.character == SettingsManager.settings.ai_selected:
				selected_card = card 
				break 
	else:
		for card in v_container.get_children():
			if card is CharacterCard and card.character == SettingsManager.settings.collab_partner_selected:
				selected_card = card 
				break

	for card in v_container.get_children():
		if card is CharacterCard and card.character != selected_card.character:
			card.modulate.a = 0.3 
	selected_card.modulate.a = 1.0 
	scroll_vertical = selected_card.id * CARD_LENGTH

func change_card_opacity(card: CharacterCard, value: float) -> void:
	var tween = get_tree().create_tween() 
	tween.tween_property(card, "modulate:a", value, 0.2)
