# Neuro Adventures
**Neuro Adventures! is a Survivors-like set in the Neuroverse.** Check out [Neuro-Adventures](https://kotgedev.itch.io/neuro-adventures) to play a demo of the game. 

This repository contains all of the code and assets for the game. 

## Development 
### Adding a new AI 
1. Create and save a new inherited scene using ai.tscn 
2. Set CharacterAnimation IdleSprite and RunSprite. See existing IdleSprite and RunSprite for the format.
3. Add the name as an entry at Globals.WhichAI 
### Adding a new Collab Partner 
1. Create and save a new inherited scene using collab_partner.tscn
2. Set CharacterAnimation IdleSprite and RunSprite. See existing IdleSprite and RunSprite for the format.
3. Add the name as an entry at Globals.WhichCollabPartner 
### Adding a new upgrade 
Upgrades available regardless of characters chosen should be placed within upgrades_db. If you want to create upgrades only available for specific characters, add them to upgrades_db_<character_name>. Create upgrades_db_<character_name> if it does not exist. When creating upgrades_db_<character_name> also update _on_map_ready() to be able to use the array. 

To create an upgrade you need: upgrade name, description (an array of descriptions for each lvl), upgrade type (Globals.UpgradeType), max_lvl, lvl, scene_template. You can add tags (An array of strings) as the last parameter for specific functionality.

All UpgradeScenes should inherit from UpgradeScene 

To implement damage modifier upgrades, use the table below. The UpgradeScene must be added to the desired group and have a function with the same name as the group. See ai.gd / collab_partner.gd to see the specifics on how damage received modifiers (Enemy -> AI or CollabPartner) work, and hitbox.gd to see the specifics on how damage given modifiers work (AI, CollabPartner, or both -> Enemy). 

Group and Function Name | Required Parameters | Return Value | Description   
---|---|---|---
damage_received_modifiers_ai | BASE_DAMAGE: float, modified_damage: float | modified_damage | Enemy -> AI
damage_received_modifiers_collab | BASE_DAMAGE: float, modified_damage: float | modified_damage | Enemy -> Collab
damage_given_modifiers_global | BASE_DAMAGE: float, modified_damage: float, area: Area2D | modified_damage | AI / Collab -> Enemy
damage_given_modifiers_ai | BASE_DAMAGE: float, modified_damage: float, area: Area2D | modified_damage | AI -> Enemy
damage_given_modifiers_collab | BASE_DAMAGE: float, modified_damage: float, area: Area2D | modified_damage | Collab -> Enemy 

## License
Code is licensed under a [MIT license](LICENSE.md) 

Art and Music is licensed under a [CC BY 4.0 Deed Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/deed.en)

