extends Collectible
class_name Exp

var disabled := false 

func fire_signal() -> void:
	Globals.collect_exp.emit(1) 
