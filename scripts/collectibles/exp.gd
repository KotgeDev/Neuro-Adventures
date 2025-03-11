extends Collectible
class_name Exp

@export var tier := 1

var disabled := false

func ready() -> void:
	# Exp with a tier of 1 will be in group 'exp1'
	# and tier of 2 in group 'exp2' and so on.
	add_to_group("exp%d" % tier)
	remove_at_timeout = false

func fire_signal() -> void:
	Globals.collect_exp.emit(Globals.exp_tier_to_value[tier])
