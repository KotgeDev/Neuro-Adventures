extends CanvasLayer

#region NODES
@onready var ai_health_bar = %AIHealthBar
@onready var collab_partner_health_bar = %CollabPartnerHealthBar
@onready var exp_bar = $EXPBar
@onready var end_game = $EndGame
@onready var center_marker = $CenterMarker
@onready var fps_counter = $FPSCounter
@onready var upgrade_menu = %UpgradeMenu
@onready var level_counter = $LevelCounter
var collab_partner
#endregion

#UI Shake Handler (Scuffed Code Ahead)
var max_offset = Vector2(2, 2) 
var rng = RandomNumberGenerator.new()
var ashakepos;
var cshakepos;
var ashake = false
var ashaketime = 0.25
var cshake = false
var cshaketime = 0.25
var exp_value = 0.0
#UI Shake Handler End

var menu_blip1: AudioStream = preload("res://assets/sfx/menublip.wav")
var menu_blip2: AudioStream = preload("res://assets/sfx/menublip2.wav")
var start_time_msec = 0.0
var pause_start_time_msec = 0.0
var total_paused_time_msec = 0.0 
var menu_allowed := true 
var upgrade_screen_on := false 
var display_level = 0

func _ready() -> void:
	ashakepos = ai_health_bar.position
	cshakepos = collab_partner_health_bar.position
	Globals.game_over.connect(_on_game_over)
	Globals.game_won.connect(_on_game_won)
	Globals.update_ai_health.connect(_on_update_ai_health)
	Globals.update_collab_partner_health.connect(_on_update_collab_partner_health)
	Globals.update_exp_bar.connect(_on_update_exp_bar)
	Globals.send_random_upgrades.connect(_on_send_random_upgrades)
	Globals.map_ready.connect(_on_map_ready)
	
func _on_map_ready() -> void:
	collab_partner = get_tree().get_first_node_in_group("collab_partner")
	start_time_msec = Time.get_ticks_msec()

func _process(delta: float) -> void:
	shake_handler(delta)
	exp_bar.value = lerpf(exp_bar.value, exp_value, delta*7)
	if Input.is_action_just_pressed("menu") and menu_allowed:
		if end_game.visible:
			hide_endgame()
		else: 
			show_endgame()
		
		%EndGameLabel.text = "PAUSED"
		%FlavorText.text = "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
		$EndGame/TimeLabel.text = "Survival time: " + calculated_survived_time()

func hide_endgame(): 
	end_game.visible = false 
	if upgrade_menu.visible:
		return
	else:
		unpause_game()

func show_endgame():
	end_game.visible = true 
	if upgrade_menu.visible:
		total_paused_time_msec += Time.get_ticks_msec() - pause_start_time_msec
		pause_start_time_msec = Time.get_ticks_msec()
	else:
		pause_game()

func pause_game() -> void:
	get_tree().paused = true
	pause_start_time_msec = Time.get_ticks_msec()

func unpause_game() -> void:
	get_tree().paused = false 
	total_paused_time_msec += Time.get_ticks_msec() - pause_start_time_msec

func _on_game_over() -> void:
	menu_allowed = false 
	pause_game()
	%EndGameLabel.text = "GAME OVER"
	%FlavorText.text = "Someone tell Vedal there is a problem with my AI"
	AudioSystem.set_music_pitch(0.05, 2.5)
	end_game.visible = true 
	
	var survival_sec: int = roundi((Time.get_ticks_msec() - start_time_msec - total_paused_time_msec) / 1000.0) 
	var min: int = int(survival_sec / 60)
	var sec: int = roundi(survival_sec % 60)
	$EndGame/TimeLabel.text = "Survived time: " + calculated_survived_time()
	
func _on_game_won() -> void:
	menu_allowed = false 
	pause_game()
	%EndGameLabel.text = "VICTORY"
	%FlavorText.text = "Sometimes when I sit here and stream, I envision myself as a goddess, overlooking my followers. "
	$EndGame/TimeLabel.text = "Elapsed time: " + calculated_survived_time()
	end_game.visible = true 

func calculated_survived_time() -> String: 
	var survival_sec: int = roundi((Time.get_ticks_msec() - start_time_msec - total_paused_time_msec) / 1000.0) 
	var min: int = int(survival_sec / 60)
	var sec: int = roundi(survival_sec % 60)
	return "%02d:%02d" % [min, sec] 

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
			
func _on_update_ai_health(max: float, health: float) -> void:
	if health >= 0.0: 
		ai_health_bar.value = health / max * 100 
		ashake = true
		ashaketime = 0.25
		
func _on_update_collab_partner_health(max: float, health: float) -> void:
	if health >= 0.0: 
		collab_partner_health_bar.value = health / max * 100 
		cshake = true
		cshaketime = 0.25

func _on_update_exp_bar(max, exp) -> void:
	exp_value = float(exp) / float(max) * 100

func _on_send_random_upgrades(upgrades: Array) -> void:
	display_level += 1 
	level_counter.text = str(display_level)
	
	if upgrades.size() == 0:
		return
	
	pause_game()
	
	$UpgradeMenu.visible = true 
	$UpgradeMenu._set_scale_zero()
	$UpgradeMenu.ui_Active = true 
	AudioSystem.set_music_volume(0.5)
	
	var container = %ChoicePanelContainer
	
	for upgrade in upgrades:
		var choice_panel
		if upgrade.upgrade_type == Globals.UpgradeType.AI_UPGRADE:
			choice_panel = $UpgradeChoicePanelAI.duplicate()
		else:
			choice_panel = $UpgradeChoicePanelCollab.duplicate()
		choice_panel.visible = true
		choice_panel.get_node("Button").pressed.connect(_on_upgrade_selected.bind(upgrade))
		choice_panel.get_node("Button").mouse_entered.connect(_on_mouse_over_upgrade)
		choice_panel.get_node("HBoxContainer").get_node("Name").text = "%s lv%d" % [upgrade.upgrade_name, upgrade.lvl + 1]
		choice_panel.get_node("HBoxContainer").get_node("Description").text = upgrade.descriptions[upgrade.lvl]
		container.add_child(choice_panel)

func _on_mouse_over_upgrade() -> void:
	AudioSystem.play_sfx(menu_blip1, collab_partner.global_position, 1.5)

func _on_upgrade_selected(upgrade: Upgrade) -> void:
	AudioSystem.play_sfx(menu_blip2, collab_partner.global_position, 2.0)
	Globals.lvl_up.emit(upgrade)
	
	$UpgradeMenu.visible = false 
	var container = %ChoicePanelContainer
	for child in container.get_children():
		child.queue_free() 
	AudioSystem.set_music_volume(1)
	unpause_game()

func _on_menu_button_pressed():
	unpause_game()
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	AudioSystem.end_music()

func _on_fps_counter_update_timer_timeout():
	fps_counter.text = "%d fps" % round(Engine.get_frames_per_second())

