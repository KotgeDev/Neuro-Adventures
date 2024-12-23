# Creating New Upgrades

A guide on creating new upgrades for Neuro Adventures! 

## Step 1: Create an UpgradeResource 
The UpgradeResource is what stores all the Upgrade data.
Upgrade Resources can be created by Create New -> Resource and searching for UpgradeResource. 
The resource must be created within one of the folders located at `resources/upgrades/` 
Simply fill out the fields with the appropriate data. 

&nbsp;&nbsp;&nbsp;&nbsp; **Upgrade Name** &nbsp;  Name of Upgrade  
&nbsp;&nbsp;&nbsp;&nbsp; **Icon** &nbsp; Texture2D, file must be stored at `assets/upgrade`  
&nbsp;&nbsp;&nbsp;&nbsp; **Descriptions** &nbsp; Description for each lvl   
&nbsp;&nbsp;&nbsp;&nbsp; **Upgrade Type** &nbsp; Which character owns this upgrade   
&nbsp;&nbsp;&nbsp;&nbsp; **Max Lvl** &nbsp; Upgrade maximum lvl    
&nbsp;&nbsp;&nbsp;&nbsp; **Scene Template** &nbsp; See next step  
&nbsp;&nbsp;&nbsp;&nbsp; **Unlimited** &nbsp; Check if upgrade can be infinitely obtained. (i.e. Gymbag Drone)  
&nbsp;&nbsp;&nbsp;&nbsp; **Tag** &nbsp; Offensive upgrades deal damage, passive upgrades improve stats 

Once an UpgradeResource has been made, add it to the corresponding UpgradeDB 
(i.e. cookies should be added to the dB of `neuro_upgrades_db.tres`)

## Step 2: Create an UpgradeScene 
The UpgradeScene is a type of Node2D that contains the functionality of the upgrade, and will be added as a child to the corresponding 
character when selected during gameplay.  
All UpgradeScenes must inherit from the class UpgradeScene. UpgradeScenes have one property, **upgrade**,
which is an object containing all neccesary upgrade data. You can use **upgrade.lvl** to access the upgrade's current lvl.  
Every time the upgrade is leveled up, including when the upgrade is first received, the **sync_level** method is run. 
Use this function to change properties depending on lvl.  
UpgradeScenes should be placed in `scenes/upgrades` and the attached script at `scripts/upgrades`

## Step 3: Implement the UpgradeScene 
For passive upgrades all you need to do is change StatsManager properties according to lvl. 
For offensive upgrades you will need to most likely fire a **projectile** at an interval. 
Projectiles objects with hitboxes. Projectile scenes should be stored at `scenes/projectiles` and the attached script at `scripts/projectiles`. 
Here are some objects that may be useful in making UpgradeScenes and projectiles.
It may be helpful to go over existing UpgradeScens to get an idea on how to implement new ones. 

### Cooldown Timer 
When using a **Timer** to fire projectiles at an interval, attach `scripts/shared/cooldown_timer.gd`  
This will give the Timer a **base_cooldown** property which you should use instead of the normal **wait_time**. 
This will make sure that all cooldowns are affected by any cooldown reduction passives. 

### Hitbox 
Two types of hitboxes exist, the ContinuousHitbox that deals damage evry couple seconds,
and the MultiHitbox that hits a set amount of times. Both hitboxes require you to set the following properties: 

&nbsp;&nbsp;&nbsp;&nbsp; **Owned By** &nbsp; Who is dealing this damage  
&nbsp;&nbsp;&nbsp;&nbsp; **Damage** &nbsp;  Amount of damage   
&nbsp;&nbsp;&nbsp;&nbsp; **Collision Mask** &nbsp; For AI, Collab Hurtbox (2) & Enemy Hurtbox (3). For Collab, only (3).  
&nbsp;&nbsp;&nbsp;&nbsp; **CollisionPolygon2D** &nbsp; Should match the projectile's shape 

MultiHitboxes require one more field:  

&nbsp;&nbsp;&nbsp;&nbsp; **Count** &nbsp; Projectile 'penetration' in other words enemies this can damage before self-destructing.
