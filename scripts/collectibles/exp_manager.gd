extends Node2D

@onready var map = get_parent()

var exp2_temp = preload("res://scenes/collectibles/exp2.tscn")

func _on_timer_timeout() -> void:
	var exp1s = get_tree().get_nodes_in_group("exp1")
	print(exp1s)
	# Convert tier1s to tier2s
	var last_i
	for i in range(exp1s.size()):
		if (i+1) % Globals.exp_tier_to_value[2] == 0:
			print(i+1)
			var exp2 = exp2_temp.instantiate()
			map.call_deferred("add_child", exp2)
			exp2.global_position = exp1s[i].global_position
			last_i = i

	var exp1s_to_delete = []
	# Delete teir1s except those that have not been converted.
	var remainder = exp1s.size() % Globals.exp_tier_to_value[1]
	for i in range(exp1s.size()):
		if i <= last_i:
			exp1s_to_delete.append(exp1s[i])

	for exp in exp1s_to_delete:
		exp.queue_free()
