extends Control

signal close_victory_achievement_screen 

var achievements_completed_this_game = []
var active := false 

@onready var badge_container = %BadgeContainer
@onready var badge_template = $Badge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AchievementManager.add_achievement.connect(_on_add_achievement)

func _on_add_achievement(index: int) -> void:
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
	if active and Input.is_action_just_pressed("close_screen"):
		active = false 
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		close_victory_achievement_screen.emit()
		await tween.tween_property(self, "modulate:a", 0.0, 1.0).finished
		visible = false 
