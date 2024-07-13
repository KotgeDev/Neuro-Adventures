extends Node2D

var ai_portal_texture = preload("res://assets/projectiles/portal2_sheet.png")

func play_animation() -> void:
	$AnimationPlayer.play("teleport")
