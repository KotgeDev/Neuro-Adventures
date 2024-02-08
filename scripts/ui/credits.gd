extends Control

signal close_credits 

func _on_return_button_pressed():
	visible = false 
	close_credits.emit() 
