extends Node
class_name Upgrade

var res: UpgradeResource
var scene: UpgradeScene
var lvl := 0

func _init(
	_res: UpgradeResource
) -> void:
	res = _res
