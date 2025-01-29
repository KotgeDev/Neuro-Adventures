extends CanvasLayer
class_name HUD

#region NODES
@onready var pause_manager = $PauseManager
@onready var ai_health_bar = %AIHealthBar
@onready var collab_partner_health_bar = %CollabPartnerHealthBar
@onready var exp_bar = $EXPBar
@onready var fps_counter = $FPSCounter
@onready var ai_bar_full = %AiBarFull
@onready var collab_partner_bar_full = %CollabPartnerBarFull
@onready var achievement_display = $AchievementDisplay
@onready var victory_display = $VictoryDisplay
@onready var level_counter: Label = $LevelCounter
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
var pause_start_time_msec = 0.0
var total_paused_time_msec = 0.0
var menu_allowed := true
var upgrade_screen_on := false
#endregion

func _ready() -> void:
	connect_signals()

	ashakepos = ai_health_bar.position
	cshakepos = collab_partner_health_bar.position
	set_fps_counter_state(SettingsManager.settings.fps_counter)
	if SettingsManager.settings.full_health_effect:
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
	Globals.change_fps_counter_state.connect(set_fps_counter_state)
	StatsManager.level_changed.connect(_on_level_changed)

	match SettingsManager.settings.ai_selected:
		Globals.CharacterChoice.NEURO:
			$HealthBars/AIIcon.texture = load("res://assets/characters/ais/neuro_icon.png")
		Globals.CharacterChoice.EVIL:
			$HealthBars/AIIcon.texture = load("res://assets/characters/ais/evil_icon.png")

	match SettingsManager.settings.collab_partner_selected:
		Globals.CharacterChoice.VEDAL:
			$HealthBars/CollabPartnerIcon.texture = load("res://assets/characters/collab_partners/vedal_icon.png")
		Globals.CharacterChoice.ANNY:
			$HealthBars/CollabPartnerIcon.texture = load("res://assets/characters/collab_partners/anny_icon.png")

func _process(delta: float) -> void:
	shake_handler(delta)
	exp_bar.value = lerpf(exp_bar.value, exp_value, delta*7)

func _on_level_changed() -> void:
	level_counter.text = "%d" % StatsManager.lvl

func _on_game_over() -> void:
	if pause_manager.game_ended:
		return

	pause_manager.game_ended = true
	pause_manager.pause_game()
	AudioSystem.set_music_pitch(0.05, 2.5)
	victory_display.display_game_over()

func _on_game_won() -> void:
	if MapManager.map_mode == MapManager.MapMode.ENDLESS:
		return

	pause_manager.game_ended = true
	pause_manager.pause_game()
	achievement_display.check_for_completed_achievements()

	if not achievement_display.achievements_completed_this_game.is_empty():
		achievement_display.show_achievements()
		await achievement_display.close_display
		victory_display.display_victory()
	else:
		victory_display.display_victory()

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

func _on_update_ai_health(max: float, health: float, shake := true) -> void:
	if SettingsManager.settings.full_health_effect:
		if health == max:
			ai_bar_full.visible = true
		else:
			ai_bar_full.visible = false

	if health >= 0.0:
		ai_health_bar.value = health / max * 100
	if shake:
		ashake = true
		ashaketime = 0.25

func _on_update_collab_partner_health(max: float, health: float, shake := true) -> void:
	if SettingsManager.settings.full_health_effect:
		if health == max:
			collab_partner_bar_full.visible = true
		else:
			collab_partner_bar_full.visible = false

	if health >= 0.0:
		collab_partner_health_bar.value = health / max * 100
	if shake:
		cshake = true
		cshaketime = 0.25

func _on_update_exp_bar(max, exp) -> void:
	exp_value = float(exp) / float(max) * 100

func _on_fps_counter_update_timer_timeout():
	fps_counter.text = "%d fps" % round(Engine.get_frames_per_second())

func set_fps_counter_state(toggled_on: bool) -> void:
	fps_counter.visible = toggled_on
