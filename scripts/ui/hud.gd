extends CanvasLayer

#region NODES
@onready var pause_manager = $PauseManager
@onready var ai_health_bar = %AIHealthBar
@onready var collab_partner_health_bar = %CollabPartnerHealthBar
@onready var exp_bar = $EXPBar
@onready var fps_counter = $FPSCounter
@onready var upgrade_menu = %UpgradeMenu
@onready var level_counter = $LevelCounter
@onready var choice_panel_container = %ChoicePanelContainer
@onready var choice_panel_template = $UpgradeChoicePanel
@onready var ai_bar_full = %AiBarFull
@onready var collab_partner_bar_full = %CollabPartnerBarFull
@onready var achievement_display = $AchievementDisplay
@onready var victory_display = $VictoryDisplay
var collab_partner: CollabPartner 
var map: MAP 
#endregion

#region UI Shake Handler (Scuffed Code Ahead)
var max_offset = Vector2(2, 2) 
var rng = RandomNumberGenerator.new()
var ashakepos;
var cshakepos;
var ashake = false
var ashaketime = 0.25
var cshake = false
var cshaketime = 0.25
var exp_value = 0.0
#endregion UI Shake Handler End

#region OTHER
var menu_blip2: AudioStream = preload("res://assets/sfx/menublip2.wav")
var pause_start_time_msec = 0.0
var total_paused_time_msec = 0.0 
var menu_allowed := true 
var upgrade_screen_on := false 
var display_level = 0
#endregion

func _ready() -> void:
	connect_signals()
	
	ashakepos = ai_health_bar.position
	cshakepos = collab_partner_health_bar.position
	set_fps_counter_state(SavedOptions.settings.fps_counter)
	if SavedOptions.settings.full_health_effect:
		ai_bar_full.visible = true
		collab_partner_bar_full.visible = true
	else: 
		ai_bar_full.visible = false
		collab_partner_bar_full.visible = false

func connect_signals() -> void:
	Globals.game_over.connect(_on_game_over)
	Globals.game_won.connect(_on_game_won)
	Globals.update_ai_health.connect(_on_update_ai_health)
	Globals.update_collab_partner_health.connect(_on_update_collab_partner_health)
	Globals.update_exp_bar.connect(_on_update_exp_bar)
	Globals.send_random_upgrades.connect(_on_send_random_upgrades)
	Globals.send_all_existing_upgrades.connect(_on_send_all_existing_upgrades)
	Globals.change_fps_counter_state.connect(set_fps_counter_state)
	Globals.map_ready.connect(_on_map_ready)
	
func _on_map_ready() -> void:
	collab_partner = get_tree().get_first_node_in_group("collab_partner") 
	map = get_tree().get_first_node_in_group("map")
	
	match SavedOptions.settings.ai_selected:
		Globals.CharacterChoice.NEURO:
			$HealthBars/AIIcon.texture = load("res://assets/characters/ais/neuro_icon.png")
		Globals.CharacterChoice.EVIL:
			$HealthBars/AIIcon.texture = load("res://assets/characters/ais/evil_icon.png")

	match SavedOptions.settings.collab_partner_selected:
		Globals.CharacterChoice.VEDAL:
			$HealthBars/CollabPartnerIcon.texture = load("res://assets/characters/collab_partners/vedal_icon.png")
		Globals.CharacterChoice.ANNY:
			$HealthBars/CollabPartnerIcon.texture = load("res://assets/characters/collab_partners/anny_icon.png")

func _process(delta: float) -> void:
	shake_handler(delta)
	exp_bar.value = lerpf(exp_bar.value, exp_value, delta*7)

func _on_game_over() -> void:
	pause_manager.game_ended = true 
	pause_manager.pause_game()
	AudioSystem.set_music_pitch(0.05, 2.5)
	victory_display.display_game_over()

func _on_game_won() -> void:
	if MapManager.map_mode == MapManager.MapMode.ENDLESS:
		return 
	
	pause_manager.game_ended = true 
	pause_manager.pause_game()
	check_for_completed_achievements()
	
	if not achievement_display.achievements_completed_this_game.is_empty():
		achievement_display.show_achievements()
		await achievement_display.close_display
		victory_display.display_victory()
	else:
		victory_display.display_victory() 

func check_for_completed_achievements() -> void:
	var status = AchievementManager.achievement_status
	if not status[0]:
		AchievementManager.add_achievement.emit(0)
	if map.current_map == Globals.MapChoice.THE_FARM and not status[1]:
		AchievementManager.add_achievement.emit(1)
	if not collab_partner.damaged_atleast_once and not status[2]:
		AchievementManager.add_achievement.emit(2)
	if map.gymbag_drone_count >= 10 and map.swarm_max and not status[3]:
		AchievementManager.add_achievement.emit(3)
	if map.raise_the_timer and not status[4]:
		AchievementManager.add_achievement.emit(4)
	if map.say_it_back_max and map.dual_strike_max and not status[5]:
		AchievementManager.add_achievement.emit(5)

func shake(obj_to_shake, source) -> void:
	obj_to_shake.position.x = source.x + max_offset.x * rng.randf_range(-1, 1)
	obj_to_shake.position.y = source.y + max_offset.y * rng.randf_range(-1, 1)

func shake_handler(delta) -> void:
	if(ashake):
		ashaketime -= delta
		shake(ai_health_bar, ashakepos)
		if(ashaketime < 0):
			ashake = false
			ai_health_bar.position = ashakepos
	if(cshake):
		cshaketime -= delta
		shake(collab_partner_health_bar, cshakepos)
		if(cshaketime < 0):
			cshake = false
			collab_partner_health_bar.position = cshakepos
			
func _on_update_ai_health(max: float, health: float, loss := true) -> void:
	if SavedOptions.settings.full_health_effect:
		if health == max: 
			ai_bar_full.visible = true 
		else:
			ai_bar_full.visible = false
	
	if health >= 0.0: 
		ai_health_bar.value = health / max * 100 
	if loss: 
		ashake = true
		ashaketime = 0.25
		
func _on_update_collab_partner_health(max: float, health: float, loss := true) -> void:
	if SavedOptions.settings.full_health_effect:
		if health == max: 
			collab_partner_bar_full.visible = true 
		else:
			collab_partner_bar_full.visible = false 
	
	if health >= 0.0: 
		collab_partner_health_bar.value = health / max * 100 
	if loss: 
		cshake = true
		cshaketime = 0.25

func _on_update_exp_bar(max, exp) -> void:
	exp_value = float(exp) / float(max) * 100

func _on_send_random_upgrades(upgrades: Array) -> void:
	display_level += 1 
	level_counter.text = str(display_level)
	
	%UpgradeLabel.visible = false
	pause_manager.pause_game()
	display_upgrades(upgrades)

func _on_send_all_existing_upgrades(upgrades: Array) -> void:
	%UpgradeLabel.visible = true 
	pause_manager.pause_game()
	display_upgrades(upgrades) 
	
func display_upgrades(upgrades: Array) -> void:
	upgrade_menu.visible = true 
	upgrade_menu._set_scale_zero()
	upgrade_menu.ui_Active = true 
	
	for upgrade in upgrades:
		var choice_panel = choice_panel_template.duplicate()
		var button = choice_panel.get_node("Button")
		var v_container = choice_panel.get_node("VBoxContainer")
		var upgrade_name = v_container.get_node("UpgradeName")
		var h_container = v_container.get_node("HBoxContainer")
		var icon = h_container.get_node("Icon")
		var description = h_container.get_node("Description")
	
		button.pressed.connect(_on_upgrade_selected.bind(upgrade))
		button.mouse_entered.connect(_on_mouse_over_upgrade)
		if upgrade.unlimited:
			upgrade_name.text = " %s [Unlimited]" % [upgrade.upgrade_name]
		else:
			upgrade_name.text = " %s [Lv%d]" % [upgrade.upgrade_name, upgrade.lvl + 1]
		icon.texture = upgrade.icon
		description.text = upgrade.descriptions[upgrade.lvl]
		choice_panel.visible = true
		choice_panel_container.add_child(choice_panel) 

func _on_mouse_over_upgrade() -> void:
	AudioSystem.play_sfx(menu_blip2, Vector2(640 / 2.0, 340 / 2.0))

func _on_upgrade_selected(upgrade: Upgrade) -> void:
	pause_manager.unpause_game()
	AudioSystem.play_sfx(menu_blip2, Vector2(640 / 2.0, 340 / 2.0))
	Globals.lvl_up.emit(upgrade)
	upgrade_menu.visible = false 
	var container = choice_panel_container
	for child in container.get_children():
		child.queue_free() 

func _on_fps_counter_update_timer_timeout():
	fps_counter.text = "%d fps" % round(Engine.get_frames_per_second())

func set_fps_counter_state(toggled_on: bool) -> void:
	fps_counter.visible = toggled_on


