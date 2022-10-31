extends "res://src/Ability/Player/GameplayAbility_Weapon_Shotgun.gd"


#func GetSpawnRotation() -> Vector2:
#	var vec : Vector2
#
#	if is_instance_valid(TargetActor):
#		vec = (TargetActor.GetTargetingPosition() - GetSpawnPosition()).normalized()
#	elif SpawnRotation != Vector2(0,0) :
#		vec = SpawnRotation 
#	else :
#		vec = Vector2(AbilityOwner.FacingDirection, 0)
#
#		if AbilityOwner is Player : 
#			if Input.is_action_pressed("shoot") :
#				if Input.is_action_pressed("move_up") :
#					vec.x = 0.0
#					vec.y -= 1.0
#				if Input.is_action_pressed("move_down") :
#					vec.x = 0.0
#					vec.y += 1.0
#
#	return vec
