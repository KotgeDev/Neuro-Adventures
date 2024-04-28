extends Node

#region Enums 
enum UpgradeType {
	AI_UPGRADE,
	COLLAB_PARTNER_UPGRADE,
}

enum Owners {
	OWNED_BY_AI,
	OWNED_BY_COLLAB_PARTNER,
	OWNED_BY_ENEMY
}

#endregion 

## connect function to this signal if an action 
## needs to be done only after the map is ready 
signal map_ready 

#region TO ENEMY SPAWNER 
signal spawn(scene_template, count: int, time_interval: float, last_batch: bool)
#endregion 

#region TO HUD
signal game_over
signal game_won 
signal update_ai_health(max_health: int, health: int)
signal update_collab_partner_health(max_health: int, health: int)
signal update_exp_bar(max_exp: int, exp: int)
signal send_random_upgrades(upgrades: Array) 
signal send_all_existing_upgrades(upgrades: Array)
signal change_fps_counter_state(toggled_on: bool)
#endregion 

#region TO UPGRADE MANAGER
signal get_random_upgrades
signal get_all_existing_upgrades 
signal lvl_up(upgrade: Upgrade)
signal remove_maxed_upgrades 
#endregion 

#region TO SPECIFIC UPGRADES
signal update_drones
signal update_pizza
#endregion 

#region TO COLLAB PARTNER OR AI 
signal collect_exp(value: int)
signal collect_cookie
signal collect_creggs
signal damage_collab_partner(damage: float)
signal damage_ai(damage: float)
signal heal_ai(hp: float)
signal add_upgrade_to_collab_partner(upgrade: Node)
signal add_upgrade_to_ai(upgrade: Node)
signal raise_the_timer(frequency: float, increase: float)
#endregion 
