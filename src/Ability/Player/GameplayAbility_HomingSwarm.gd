extends "res://src/Ability/Player/GameplayAbility_Weapon_Shotgun.gd"

onready var area_enemy_detection: Area2D = $Area2D_EnemyDetection
onready var line_of_sight: RayCast2D = $RayCast_LineOfSight

var Targets = []

func Activate():
	Targets.clear()
	var potential_targets = area_enemy_detection.get_overlapping_areas()
	for area in potential_targets : 
		var body = area.GetOwnerObject()
		line_of_sight.set_cast_to( to_local(body.GetTargetingPosition()) )
		line_of_sight.force_raycast_update()
		if line_of_sight.is_colliding() :
			continue
			
		if body.GetTeam() != GlobalFunctions.GetOwnerObject(self).GetTeam():
			Targets.push_back(body)
			
	.Activate()
	
func Deactivate():
	.Deactivate()

func OnSpawnBullet(bullet):
	if Targets.size() > 0 : 
		var picked_target = Targets[randi() % Targets.size()]
		print(Targets)
		if is_instance_valid(picked_target) : 
			bullet.look_at(picked_target.GetTargetingPosition())
			bullet.SetHomeTargetActor(picked_target)
			bullet.GetMovementComponent().bUseHoming = true
			bullet.GetMovementComponent().HomingStrength = 5000
			bullet.GetMovementComponent().Init()
		else : 
			for target in Targets:
				if !is_instance_valid(target) :
					Targets.erase(target)
	pass
