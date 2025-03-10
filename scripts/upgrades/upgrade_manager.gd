extends Node2D
class_name UpgradeManager

## Endless upgrades will appear starting this level
const SOFT_LVL_CAP := 24

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
var endless_upgrades_added := false
var drone_upgrade: Upgrade

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

	for upgrade in upgrades_pool:
		if upgrade.res.upgrade_type == UpgradeResource.UpgradeType.DRONE_UPGRADE:
			drone_upgrade = upgrade

	lvl_up(find_upgrade("Pipes"))
	lvl_up(find_upgrade("Pipes"))
	lvl_up(find_upgrade("Pipes"))
	lvl_up(find_upgrade("Pipes"))
	lvl_up(find_upgrade("Pipes"))

func find_upgrade(upgrade_name: String) -> Upgrade:
	# Past version name check
	if CharacterManager.past_upgrade_name_map.has(upgrade_name):
		upgrade_name = CharacterManager.past_upgrade_name_map[upgrade_name]

	for upgrade in upgrades_pool:
		if upgrade.res.upgrade_name == upgrade_name:
			return upgrade
	push_error("No upgrade node named ", upgrade_name)
	return null

func add_upgrades_to_pool(upgrades: Array) -> void:
	for resource in upgrades:
		var upgrade_obj = Upgrade.new(
			resource
		)
		upgrades_pool.append(upgrade_obj)

func request_random_upgrades() -> void:
	var pool = return_upgrades_pool()
	var results = []

	pool.shuffle()

	for i in range(3):
		results.append(find_upgrade(pool[i]))
		pool = pool.filter(func (x): return x != pool[i])

	Globals.show_three_random_upgrades.emit(results)

func return_upgrades_pool() -> Array:
	# Remove maxed upgrades
	for upgrade in upgrades_pool:
		if upgrade.res.upgrade_type == UpgradeResource.UpgradeType.ENDLESS_UPGRADE:
			pass
		elif upgrade.res.max_lvl == upgrade.lvl:
			upgrade.res.weight = 0

	# Add endless upgrades if requirement met
	if !endless_upgrades_added and StatsManager.lvl >= SOFT_LVL_CAP:
		add_upgrades_to_pool(CharacterManager.endless_upgrades_db)
		endless_upgrades_added = true

	# Generate pool
	var pool = []
	for upgrade in upgrades_pool:
		for i in range(upgrade.res.weight):
			pool.append(upgrade.res.upgrade_name)

	return pool

func request_all_existing_non_max_upgrades() -> void:
	var result := []

	for upgrade in existing_upgrades:
		if upgrade.res.upgrade_type == UpgradeResource.UpgradeType.ENDLESS_UPGRADE \
				or upgrade.res.max_lvl != upgrade.lvl:
			result.append(upgrade)

	Globals.show_all_existing_upgrades.emit(result)

func lvl_up(upgrade: Upgrade) -> void:
	var is_endless = upgrade.res.upgrade_type == UpgradeResource.UpgradeType.ENDLESS_UPGRADE
	var is_drone = upgrade.res.upgrade_type == UpgradeResource.UpgradeType.DRONE_UPGRADE

	if upgrade.lvl == 0 or is_endless or is_drone:
		if not existing_upgrades.has(upgrade):
			existing_upgrades.append(upgrade)

		if is_endless or is_drone:
			upgrade.lvl += 1
		else:
			upgrade.lvl = 1
		var scene = upgrade.res.scene_template.instantiate()
		#WARNING: Cyclic reference. Should be allowed in godot 4.2 though
		# adding a warning just in case
		upgrade.scene = scene
		scene.upgrade = upgrade

		if upgrade.res.upgrade_type == UpgradeResource.UpgradeType.AI_UPGRADE or is_drone:
			Globals.add_upgrade_to_ai.emit(scene)
		elif upgrade.res.upgrade_type == UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			Globals.add_upgrade_to_collab_partner.emit(scene)
		elif is_endless:
			add_child(scene)
	else:
		upgrade.lvl += 1

	upgrade.scene.sync_level()

func _on_request_collab_upgrades() -> void:
	var result := []

	for scene in existing_upgrades:
		var upgrade = scene as Upgrade
		if upgrade.res.upgrade_type == UpgradeResource.UpgradeType.COLLAB_PARTNER_UPGRADE:
			result.append(upgrade)

	Globals.send_collab_upgrades.emit(result)

func _on_request_ai_upgrades() -> void:
	var result := []

	for scene in existing_upgrades:
		var upgrade = scene as Upgrade
		if upgrade.res.upgrade_type == UpgradeResource.UpgradeType.AI_UPGRADE or \
				upgrade.res.upgrade_type == UpgradeResource.UpgradeType.DRONE_UPGRADE:
			result.append(upgrade)

	Globals.send_ai_upgrades.emit(result)

func _on_drone_auto_changed(status: bool) -> void:
	if status:
		drone_auto_timer.start(2.0 * 60.0)
	else:
		drone_auto_timer.stop()

func _on_drone_auto_timer_timeout() -> void:
	if drone_upgrade.lvl == drone_upgrade.res.max_lvl:
		drone_auto_timer.stop()
		return
	lvl_up(drone_upgrade)
