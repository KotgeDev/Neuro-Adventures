extends Control

signal close_achievements 

@onready var base_sprite = preload("res://assets/achievements/base.png")
@onready var base_mono_sprite = preload("res://assets/achievements/base_mono.png")
@onready var backslash_sprite = preload("res://assets/achievements/unknown.png")

@onready var achievements_container = %AchievementsContainer
@onready var achievement_panel_template = $AchievementPanel

func _ready() -> void:
	var achievements = AchievementManager.achievement_objects
	var status = AchievementManager.achievement_status
	
	for index in achievements.keys():
		var achievement = achievements[index] as Achievement
		
		var achievement_panel = achievement_panel_template.duplicate()  
		var v_container = achievement_panel.get_node("VBoxContainer")
		var title = v_container.get_node("Labels").get_node("Title")
		var h_container = v_container.get_node("HBoxContainer")
		var base = h_container.get_node("Sprites").get_node("Base")
		var icon =  h_container.get_node("Sprites").get_node("Icon")
		var requirement = h_container.get_node("Requirement")
		
		if status[index]:  # If completed achievement 
			title.text = " %s" % [achievement.title] 
			base.texture = base_sprite
			icon.texture = achievement.icon
			requirement.text = achievement.requirement
			
		else:  # If achievmenet has not been completed 
			title.text = " ???" 
			base.texture = base_mono_sprite
			icon.texture = backslash_sprite
			requirement.text = achievement.requirement
		
		achievement_panel.visible = true 
		achievements_container.add_child(achievement_panel)

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
