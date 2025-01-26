extends ScrollContainer

const SCREEN_HALF_Y = 180
const SCREEN_HALF_X = 320
const PANEL_LENGTH = 200

@onready var v_container: VBoxContainer = %VBoxContainer
@onready var timer = %Timer

@export var selected_panel: StatsPanel

var scrolling := false
var timer_on := false

func _ready() -> void:
	timer.wait_time = 0.2
	timer.timeout.connect(_on_timer_timeout)

	await get_tree().process_frame
	set_default()

	for panel in v_container.get_children():
		if panel is StatsPanel:
			panel.selected.connect(_on_panel_selected)

func _process(delta) -> void:
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

func _on_panel_selected(panel: StatsPanel) -> void:
	selected_panel = panel
	select_panel()

func on_scroll_started() -> void:
	for panel in v_container.get_children():
		if panel is StatsPanel:
			change_panel_opacity(panel, 1.0)

func on_scroll_ended() -> void:
	for panel in v_container.get_children():
		if panel is StatsPanel and panel_highlighted(panel):
			selected_panel = panel
			select_panel()
			return

func panel_highlighted(panel: StatsPanel) -> bool:
	if panel.global_position.y <= SCREEN_HALF_Y and \
		SCREEN_HALF_Y <= panel.global_position.y + PANEL_LENGTH:
		return true
	else:
		return false

var scroll_tween: Tween
func select_panel() -> void:
	for panel in v_container.get_children():
		if panel is StatsPanel and panel.id != selected_panel.id:
			change_panel_opacity(panel, 0.3)
	change_panel_opacity(selected_panel, 1.0)

	if scroll_tween: scroll_tween.kill()
	var scroll_tween = create_tween()
	scroll_tween.tween_property(self, "scroll_vertical", selected_panel.id * PANEL_LENGTH , 0.3)

func set_default() -> void:
	for panel in v_container.get_children():
		if panel is StatsPanel and panel.id != selected_panel.id:
			panel.modulate.a = 0.3
	selected_panel.modulate.a = 1.0
	scroll_vertical = selected_panel.id * PANEL_LENGTH

func change_panel_opacity(panel: StatsPanel, value: float) -> void:
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", value, 0.2)
