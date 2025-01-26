extends Control

signal close_display

var achievements_completed_this_game = []
var active := false

@onready var badge_container = %BadgeContainer
@onready var badge_template = $Badge

func check_for_completed_achievements() -> void:
	var collab_partner = get_tree().get_first_node_in_group(Globals.COLLAB_GROUP_NAME)
	var map = get_tree().get_first_node_in_group(Globals.MAP_GROUP_NAME)
	var status = AchievementManager.achievement_status
	var settings = SettingsManager.settings as Settings

	if not status[0]:
		add_achievement(0)
	if settings.map_selected == Globals.MapChoice.THE_FARM and not status[1]:
		add_achievement(1)
	if not collab_partner.damaged_atleast_once and not status[2]:
		add_achievement(2)
	if map.gymbag_drone_count >= 10 and map.swarm_max and not status[3]:
		add_achievement(3)
	if map.raise_the_timer and not status[4]:
		add_achievement(4)
	if map.say_it_back_max and map.dual_strike_max and not status[5]:
		add_achievement(5)

func add_achievement(index: int) -> void:
	AchievementManager.add_achievement.emit(index)
	achievements_completed_this_game.append(index)

func show_achievements() -> void:
	visible = true
	active = true
	var achievements = AchievementManager.achievement_objects

	for index in achievements_completed_this_game:
		var achievement = achievements[index] as Achievement

		var badge = badge_template.duplicate()
		var h_container = badge.get_node("HBoxContainer")
		var icon = h_container.get_node("Sprites").get_node("Icon")
		var title = h_container.get_node("Title")

		icon.texture = achievement.icon
		title.text = achievement.title

		badge.visible = true
		badge_container.add_child(badge)

	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	await tween.tween_property(self, "modulate:a", 1.0, 1.0).finished

	for child in badge_container.get_children():
		var badge_tween = get_tree().create_tween()
		badge_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		await badge_tween.tween_property(child.get_node("HBoxContainer"), "modulate:a", 1.0, 1.5).finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active and Input.is_action_just_pressed("continue"):
		active = false
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		close_display.emit()
		await tween.tween_property(self, "modulate:a", 0.0, 1.0).finished
		visible = false
