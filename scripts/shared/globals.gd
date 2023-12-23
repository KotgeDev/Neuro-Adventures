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

#region OTHER
signal map_ready 
#endregion 

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
#endregion 

#region TO UPGRADE MANAGER
signal add_specific_upgrades(upgrades: Array) 
signal get_random_upgrades
signal lvl_up(upgrade: Upgrade)
#endregion 

#region TO COLLAB PARTNER OR AI 
signal damage_collab_partner(damage: float)
signal damage_ai(damage: float)
signal add_upgrade_to_collab_partner(upgrade: Node)
signal add_upgrade_to_ai(upgrade: Node)
#endregion 
