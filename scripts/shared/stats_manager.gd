extends Node

# These signals are emited from here
signal increase_max_hp
signal increase_speed
signal reduce_cooldown
signal reduce_ai_cooldown
signal reduce_collab_cooldown
signal increase_collection_range
signal filter_changed
signal evasion_changed
signal ai_evasion_changed
signal collab_evasion_changed
signal drone_auto_changed
signal level_changed
signal exp_passive_changed
signal insurgency_changed

# Emited from CollabPartner when speed is altered
signal collab_max_speed_changed
# Emited from AI when speed is altered
signal ai_max_speed_changed
# Emited from AI when health is changed
signal ai_hp_changed

# All properties in this autoload will be reset to:
# false if bool, 1 if int, and 0.0 if float
# unless specified otherwise

# Level
var lvl: int :
	set(value):
		lvl = value
		level_changed.emit()
# Lives
var ai_life: int
# EXP
var exp_passive: bool :
	set(value):
		exp_passive = value
		exp_passive_changed.emit(value)
# Drone
var drone_count: int
var drone_atk_inc: float
var drone_spd_inc: float
var drone_automation: bool :
	set(value):
		drone_automation = value
		drone_auto_changed.emit(value)
# Max Hp Increase Percentage
var max_hp_inc_pct: float :
	set(new_increase):
		max_hp_inc_pct = new_increase
		increase_max_hp.emit(new_increase)
# Speed Increase
var speed_increase: float :
	set(new_increase):
		speed_increase = new_increase
		increase_speed.emit(new_increase)
# Invincibility
var collab_invincible: bool
# Collection Range Increase
var cr_increase: float :
	set(new_increase):
		cr_increase = new_increase
		increase_collection_range.emit(new_increase)
# Evasion Increase
var evasion: float :
	set(value):
		evasion = value
		evasion_changed.emit()
var ai_evasion: float :
	set(value):
		ai_evasion = value
		ai_evasion_changed.emit()
var collab_evasion: float :
	set(value):
		collab_evasion = value
		collab_evasion_changed.emit()
# Cooldown Reduction
var cd_reduction: float :
	set(value):
		cd_reduction = value
		reduce_cooldown.emit()
var ai_cd_reduction: float :
	set(value):
		ai_cd_reduction = value
		reduce_ai_cooldown.emit()
var collab_cd_reduction: float :
	set(value):
		collab_cd_reduction = value
		reduce_collab_cooldown.emit()
# Filter
var filter: float :
	set(value):
		filter = value
		filter_changed.emit()
# Attack Increase
## ATK Increase should be additive.
## If you have both a +10% and +20% ATK increase
## it should become +30% ATK (atk_inc = 0.3)
var atk_inc: float
var ai_atk_inc: float
var collab_atk_inc: float
# Attack Constant Increase
## Constant ATK is added at the end of ATK calculations
var atk_const: float
var ai_atk_const: float
var collab_atk_const: float
# Attack Multiplier Increase
## ATK Multiplier should be multiplicative.
## If you have both a x1.1 and x1.2 ATK Multiplier
## it should become x1.32 ATK (atk_mult = 1.32)
var atk_mult: float
var ai_atk_mult: float
var collab_atk_mult: float
# Damage Reduction
var ai_dmg_red: float :
	set(value):
		ai_dmg_red = value
		print(value)
# Insurgency
var insurgency : bool :
	set(value):
		insurgency = value
		insurgency_changed.emit(value)
# Harmony
var harmony : bool
var chase_radius_dec : float

func reset() -> void:
	var flags = PROPERTY_USAGE_SCRIPT_VARIABLE
	for stat in get_property_list():
		if (stat.usage & flags > 0):
			if stat.type == 1:
				self[stat.name] = false
			elif stat.type == 2:
				self[stat.name] = 1
			elif stat.type == 3:
				self[stat.name] = 0.0

	atk_mult = 1.0
	ai_atk_mult = 1.0
	collab_atk_mult = 1.0

func get_final_ai_atk(damage: float) -> float:
	return (
		damage
		* (1.0 + StatsManager.atk_inc + StatsManager.ai_atk_inc)
		* (StatsManager.atk_mult * StatsManager.ai_atk_mult)
		+ (StatsManager.atk_const + StatsManager.ai_atk_const)
	)

func get_final_drone_atk(damage: float) -> float:
	return (
		damage
		* (1.0 + StatsManager.atk_inc + StatsManager.ai_atk_inc + StatsManager.drone_atk_inc)
		* (StatsManager.atk_mult * StatsManager.ai_atk_mult)
		+ (StatsManager.atk_const + StatsManager.ai_atk_const)
	)

func get_final_collab_atk(damage: float) -> float:
	return (
		damage
		* (1.0 + StatsManager.atk_inc + StatsManager.collab_atk_inc)
		* (StatsManager.atk_mult * StatsManager.collab_atk_mult)
		+ (StatsManager.atk_const + StatsManager.collab_atk_const)
	)

func get_final_ai_cd(cooldown: float) -> float:
	var t_cd_red = min(
		StatsManager.cd_reduction + StatsManager.ai_cd_reduction,
		Globals.MAX_CD_RED
	)
	return cooldown * (1-t_cd_red)

func get_final_collab_cd(cooldown: float) -> float:
	var t_cd_red = min(
		StatsManager.cd_reduction + StatsManager.collab_cd_reduction,
		Globals.MAX_CD_RED
	)
	return cooldown * (1-t_cd_red)
