## Parent class for all upgrade scenes.
## Upgrade scenes must be added as a direct child to either
## Collab Partners or AIs 
## All upgrade properties that require balancing 
## should be mutable from the UpgradeScene 
## inspector through export variables
extends Node2D
class_name UpgradeScene  

var upgrade: Upgrade

## Override to use. 
func sync_level() -> void:
	pass
