extends ColorRect

@onready var lvls: VBoxContainer = %Lvls
@onready var icon: TextureRect = %Icon
@onready var outline: TextureRect = %Outline
@onready var upgrade_name: Label = %UpgradeName
@onready var initial_stats: RichTextLabel = %InitialStats
@onready var final_stats: RichTextLabel = %FinalStats
@onready var lvl_panel: ColorRect = $"../LvlPanel"

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		_on_close_button_pressed()

func view(upgrade: UpgradeResource, outline_texture: Texture2D) -> void:
	visible = true

	icon.texture = upgrade.icon
	outline.texture = outline_texture
	upgrade_name.text = upgrade.upgrade_name
	initial_stats.text = ""
	for stat in upgrade.stats:
		initial_stats.text += "%s: %s\n" % [stat, upgrade.stats[stat][0]]
	initial_stats.text = initial_stats.text.left(-1)
	final_stats.text = ""
	for stat in upgrade.stats:
		final_stats.text += "%s: %s\n" % [stat, upgrade.stats[stat][1]]
	final_stats.text = final_stats.text.left(-1)

	var loop_count: int

	if upgrade.upgrade_type == UpgradeResource.UpgradeType.DRONE_UPGRADE:
		loop_count = 1
	else:
		loop_count = upgrade.max_lvl

	for lvl in range(loop_count):
		var new_panel = lvl_panel.duplicate()
		var container = new_panel.get_node("VBoxContainer")
		var level = container.get_node("Level")
		var description = container.get_node("Description")

		level.text = " %d " % [lvl + 1]
		description.text = upgrade.descriptions[lvl]

		new_panel.visible = true
		lvls.add_child(new_panel)

func _on_close_button_pressed() -> void:
	visible = false

	for child in lvls.get_children():
		child.queue_free()
