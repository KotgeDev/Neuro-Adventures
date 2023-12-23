extends CanvasLayer

@onready var ai_health_bar = $AIHealthBar
@onready var collab_partner_health_bar = $CollabPartnerHealthBar
@onready var exp_bar = $EXPBar
@onready var end_game = $EndGame

var menu_allowed := true 

func _ready() -> void:
	Globals.game_over.connect(_on_game_over)
	Globals.game_won.connect(_on_game_won)
	Globals.update_ai_health.connect(_on_update_ai_health)
	Globals.update_collab_partner_health.connect(_on_update_collab_partner_health)
	Globals.update_exp_bar.connect(_on_update_exp_bar)
	Globals.send_random_upgrades.connect(_on_send_random_upgrades)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu") and menu_allowed:
		%EndGameLabel.text = ""
		%FlavorText.text = ""
		
		if end_game.visible:
			get_tree().paused = false 
			end_game.visible = false
		else:
			get_tree().paused = true
			end_game.visible = true 

func _on_game_over() -> void:
	menu_allowed = false 
	get_tree().paused = true 
	%EndGameLabel.text = "GAME OVER"
	%FlavorText.text = "Someone tell Vedal there is a problem with my AI"
	end_game.visible = true 
	
func _on_game_won() -> void:
	menu_allowed = false 
	get_tree().paused = true 
	%EndGameLabel.text = "VICTORY"
	%FlavorText.text = "Sometimes when I sit here and stream, I envision myself as a goddess, overlooking my followers. "
	end_game.visible = true 
	

func _on_update_ai_health(max: float, health: float) -> void:
	if health >= 0.0: 
		ai_health_bar.value = health / max * 100 

func _on_update_collab_partner_health(max: float, health: float) -> void:
	if health >= 0.0: 
		collab_partner_health_bar.value = health / max * 100 

func _on_update_exp_bar(max, exp) -> void:
	exp_bar.value = float(exp) / float(max) * 100

func _on_send_random_upgrades(upgrades: Array) -> void:
	if upgrades.size() == 0:
		return
	
	get_tree().paused = true 
	
	$UpgradeMenu.visible = true 
	
	var container = %ChoicePanelContainer
	
	for upgrade in upgrades:
		var choice_panel
		if upgrade.upgrade_type == Globals.UpgradeType.AI_UPGRADE:
			choice_panel = $UpgradeChoicePanelAI.duplicate()
		else:
			choice_panel = $UpgradeChoicePanelCollab.duplicate()
		choice_panel.visible = true 
		choice_panel.get_node("Button").pressed.connect(_on_upgrade_selected.bind(upgrade))
		choice_panel.get_node("HBoxContainer").get_node("Name").text = "%s lv%d" % [upgrade.upgrade_name, upgrade.lvl + 1]
		choice_panel.get_node("HBoxContainer").get_node("Description").text = upgrade.descriptions[upgrade.lvl]
		container.add_child(choice_panel)
		
func _on_upgrade_selected(upgrade: Upgrade) -> void:
	Globals.lvl_up.emit(upgrade)
	
	$UpgradeMenu.visible = false 
	var container = %ChoicePanelContainer
	for child in container.get_children():
		child.queue_free() 
	
	get_tree().paused = false 

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/maps/farm.tscn")
	
func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
