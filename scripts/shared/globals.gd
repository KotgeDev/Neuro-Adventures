extends Node

const MAP_GROUP_NAME := "map"
const AI_GROUP_NAME := "ai"
const COLLAB_GROUP_NAME := "collab_partner"
const DIR_MANAGER_GROUP_NAME := "dir_manager"
const FLASH_TIME := 0.05
const MAX_CD_RED := 0.6

var exp_tier_to_value = {
	1: 1,
	2: 5
}

var tier_to_texture = {
	1: preload("res://assets/directives/tier1.png"),
	2: preload("res://assets/directives/tier2.png"),
	3: preload("res://assets/directives/tier3.png"),
	4: preload("res://assets/directives/special.png")  # 4 == special
}

#region Enums
enum Owners {
	OWNED_BY_AI,
	OWNED_BY_COLLAB_PARTNER,
	OWNED_BY_ENEMY
}

enum MapChoice {
	THE_FARM
}

enum CharacterChoice {
	NEURO,
	EVIL,
	VEDAL,
	ANNY,
	NONE
}
#endregion

## connect function to this signal if the function
## needs to be run only after the map is ready
## and you are not sure if the map will be ready at that point
signal map_ready

#region TO ENEMY SPAWNER
signal spawn(scene_template, count: int, time_interval: float, last_batch: bool)
#endregion

#region TO MAP
signal add_collectible_generator(gen: CollectibleGenerator)
signal enemy_killed(value: int)
#endregion

#region TO HUD
signal game_over
signal game_won
signal update_ai_health(max_health: int, health: int)
signal update_collab_partner_health(max_health: int, health: int)
signal update_exp_bar(max_exp: int, exp: int)
signal change_fps_counter_state(toggled_on: bool)
signal switch_follow
signal switch_loading
signal switch_stop
#endregion

#region TO UPGRADE MENU
signal show_three_random_upgrades(upgrades: Array)
signal show_all_existing_upgrades(upgrades: Array)
#endregion

#region TO DIRECTIVE MENU
signal show_directive_choices(directives: Array, special: bool, reroll: bool)
#endregion

#region TO UPGRADE MANAGER
signal request_random_upgrades
signal request_all_existing_non_max_upgrades
signal request_collab_upgrades
signal request_ai_upgrades
signal lvl_up(upgrade: Upgrade)
#endregion

#region TO DIRECTIVE MANAGER
signal request_random_directives(special: bool, reroll: bool)
signal request_special_directives
signal add_directive(directive: Directive)
signal remove_directive(directive: Directive)
#endregion

#region TO STATS MENU
signal send_collab_upgrades(upgrades: Array)
signal send_ai_upgrades(upgrades: Array)
#endregion

#region TO SPECIFIC UPGRADES
signal update_drones
signal update_pizza
signal update_stars(enemy_in_range: bool)
signal ai_attack(damage: float)
#endregion

#region TO COLLAB PARTNER OR AI
signal collect_exp(value: int)
signal collect_cookie
signal collect_creggs
signal collect_orange
signal damage_collab_partner(damage: float)
signal damage_ai(damage: float)
signal heal_ai(hp: float)
signal add_upgrade_to_collab_partner(upgrade: Node)
signal add_upgrade_to_ai(upgrade: Node)
signal raise_the_timer(frequency: float, increase: float)
#endregion
