extends Collectible
class_name Exp

@onready var exp_lv2_template = preload("res://scenes/collectibles/exp_lv2.tscn")

var disabled := false 

func fire_signal() -> void:
	Globals.collect_exp.emit(1) 

func _on_area_2d_area_entered(area):
	if area.get_parent() is Exp and not disabled: 
		var exp = area.get_parent() as Exp
		exp.disabled = true 
		exp.queue_free()
		
		var exp_lv2 = exp_lv2_template.instantiate()
		exp_lv2.global_position = global_position
		get_parent().add_child(exp_lv2) 
		queue_free() 
