extends Node2D
class_name UpgradeManager

@onready var drone_auto_timer: Timer = $DroneAutoTimer

func _ready() -> void:
	Globals.request_random_upgrades.connect(request_random_upgrades)
	Globals.request_all_existing_non_max_upgrades.connect(request_all_existing_non_max_upgrades)
	Globals.lvl_up.connect(lvl_up)
	Globals.map_ready.connect(_on_map_ready)
	Globals.request_ai_upgrades.connect(_on_request_ai_upgrades)
	Globals.request_collab_upgrades.connect(_on_request_collab_upgrades)
	StatsManager.drone_auto_changed.connect(_on_drone_auto_changed)


var upgrades_pool = []
var existing_upgrades = []
var ai_selected
var collab_selected

func _on_map_ready() -> void:
	add_upgrades_to_pool(CharacterManager.all_ai_db)
	add_upgrades_to_pool(CharacterManager.all_collab_db)

	ai_selected = SettingsManager.settings.ai_selected
	collab_selected = SettingsManager.settings.collab_partner_selected
	add_upgrades_to_pool(CharacterManager.character_data[ai_selected].db)
	add_upgrades_to_pool(CharacterManager.character_data[collab_selected].db)

	var ai_defaults = SettingsManager.default_upgrades[ai_selected]
	var collab_defaults = SettingsManager.default_upgrades[collab_selected]

	if ai_defaults.size() == 2:
		lvl_up(find_upgrade(ai_defaults[0]))
		lvl_up(find_upgrade(ai_defaults[1]))
	elif ai_defaults.size() == 1:
		lvl_up(find_upgrade(ai_defaults[0]))
	if collab_defaults.size() == 2:
		lvl_up(find_upgrade(collab_defaults[0]))
		lvl_up(find_upgrade(collab_defaults[1]))
	elif collab_defaults.size() == 1:
		lvl_up(find_upgrade(collab_defaults[0]))

func find_upgrade(upgrade_name: String) -> Upgrade:
	# Past version name check
	if CharacterManager.past_upgrade_name_map.has(upgrade_name):
		upgrade_name = CharacterManager.past_upgrade_name_map[upgrade_name]

	for upgrade in upgrades_pool:
		if upgrade.upgrade_name == upgrade_name:
			return upgrade
	push_error("No upgrade node named ", upgrade_name)
	return null

func add_upgrades_to_pool(upgrades: Array) -> void:
	for data in upgrades:
		var upgrade_res: UpgradeResource = data
		var upgrade_obj = Upgrade.new(
			upgrade_res.upgrade_name,
			upgrade_res.icon,
			upgrade_res.descriptions,
			upgrade_res.upgrade_type,
			upgrade_res.max_lvl,
			0,
			upgrade_res.scene_template,
			upgrade_res.unlimited,
			upgrade_res.tag
		)
		upgrades_pool.append(upgrade_obj)

func request_random_upgrades() -> void:
	remove_maxed_upgrades()

	var temp_upgrades_db = upgrades_pool.duplicate()
	var random_upgrades = []

	if temp_upgrades_db.size() < 3:
		Globals.show_three_random_upgrades.emit(temp_upgrades_db)
		return

	for i in range(3):
		var random_index = randi() % temp_upgrades_db.size()
		random_upgrades.append(temp_upgrades_db[random_index])
		temp_upgrades_db.remove_at(random_index)

	Globals.show_three_random_upgrades.emit(random_upgrades)

func request_all_existing_non_max_upgrades() -> void:
	var result := []

	for upgrade in existing_upgrades:
		if upgrade.max_lvl != upgrade.lvl:
			result.append(upgrade)

	Globals.show_all_existing_upgrades.emit(result)

func remove_maxed_upgrades() -> void:
	var to_remove = []

	for upgrade in upgrades_pool:
		if upgrade.max_lvl == upgrade.lvl:
			to_remove.append(upgrade)

	for upgrade in to_remove:
		upgrades_pool.erase(upgrade)

func lvl_up(upgrade: Upgrade) -> void:
	if upgrade.lvl == 0:
		if not existing_upgrades.has(upgrade):
			existing_upgrades.append(upgrade)

		upgrade.lvl = 1
		var scene = upgrade.scene_template.instantiate()
		#WARNING: Cyclic reference. Should be allowed in godot 4.2 though
		# adding a warning just in case
		upgrade.scene = scene
		scene.upgrade = upgrade

		if upgrade.upgrade_type == UpgradeResource.UpgradeType.AI_UPGRADE:
			Globals.add_upgrade_to_ai.emit(scene)
		elif upgrade.upgrade_type == UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			Globals.add_upgrade_to_collab_partner.emit(scene)
	else:
		upgrade.lvl += 1

	upgrade.scene.sync_level()

func _on_request_collab_upgrades() -> void:
	var result := []

	for scene in existing_upgrades:
		var upgrade = scene as Upgrade
		if upgrade.upgrade_type == UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			result.append(upgrade)

	Globals.send_collab_upgrades.emit(result)

func _on_request_ai_upgrades() -> void:
	var result := []

	for scene in existing_upgrades:
		var upgrade = scene as Upgrade
		if upgrade.upgrade_type == UpgradeResource.UpgradeType.AI_UPGRADE:
			result.append(upgrade)

	Globals.send_ai_upgrades.emit(result)

func _on_drone_auto_changed(status: bool) -> void:
	if status:
		drone_auto_timer.start(2.0 * 60.0)
	else:
		drone_auto_timer.stop()

func _on_drone_auto_timer_timeout() -> void:
	print("Spawning Drone")
	# TODO: Store each drone name in character instead of having to type it here

	if ai_selected == Globals.CharacterChoice.NEURO:
		lvl_up(find_upgrade("Swarm Drone"))
	elif ai_selected == Globals.CharacterChoice.EVIL:
		lvl_up(find_upgrade("Pizza Drone"))
