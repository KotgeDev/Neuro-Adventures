extends Node2D

const MAX_EXP_REQUIRED := 50
const REPLACE_SIZE := 25

@onready var map = get_parent()

var exp2_temp = preload("res://scenes/collectibles/exp2.tscn")

func _on_timer_timeout() -> void:
	var exp1s = get_tree().get_nodes_in_group("exp1")

	if exp1s.size() < MAX_EXP_REQUIRED:
		return

	var size = exp1s.size() - REPLACE_SIZE

	# Convert tier1s to tier2s
	var last_i
	for i in range(size):
		if (i+1) % Globals.exp_tier_to_value[2] == 0:
			var exp2 = exp2_temp.instantiate()
			map.call_deferred("add_child", exp2)
			exp2.global_position = exp1s[i].global_position
			last_i = i

	var exp1s_to_delete = []
	# Delete teir1s except those that have not been converted.
	for i in range(size):
		if i <= last_i:
			exp1s_to_delete.append(exp1s[i])

	for exp in exp1s_to_delete:
		exp.queue_free()
