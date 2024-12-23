extends Node

signal increase_max_hp 
signal increase_speed
signal reduce_cooldown
signal increase_collection_range

# These values will be reset to false or 0.0 unless specified otherwise

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
var ai_invincible: bool 
var collab_invincible: bool 
# Collection Range Increase 
var cr_increase: float :
	set(new_increase): 
		cr_increase = new_increase 
		increase_collection_range.emit(new_increase)
# Evasion Increase
var evasion: float   
var ai_evasion: float  
var collab_evasion: float  
# Cooldown Reduction 
var cd_reduction: float :
	set(new_reduction):
		cd_reduction = new_reduction 
		reduce_cooldown.emit(new_reduction) 
# Filter  
var filter: float 
# Attack Increase 
var atk_increase: float  
var ai_atk_increase: float  
var collab_atk_increase: float  
# Attack Constant Increase 
var atk_const_increase: float  
var ai_atk_const_increase: float  
var collab_atk_const_increase: float  
# Attack Multiplier Increase 
var atk_mult: float 
var ai_atk_mult: float  
var collab_atk_mult: float 

func reset() -> void: 
	var flags = PROPERTY_USAGE_SCRIPT_VARIABLE
	for stat in get_property_list():
		if (stat.usage & flags > 0): 
			if stat.type == 1:
				self[stat.name] = false 
			elif stat.type == 3: 
				self[stat.name] = 0.0 
			
	atk_mult = 1.0
	ai_atk_mult = 1.0 
	collab_atk_mult = 1.0 
