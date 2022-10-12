extends "res://src/Ability/GameplayAbility_ActorSpawner.gd"


func SpawnActor() -> void:
	var bullet = Bullet.instance()
	bullet.set_as_toplevel(bUseSetAsTopLevel)
	add_child(bullet)
	
	bullet.global_position = GetSpawnPosition()
	var velocity = GetSpawnRotation()
	bullet.set_global_rotation(velocity.angle())
	bullet.Init(AbilityOwner, self, GameplayeEffect_Template)
	bullet.SetHomeTargetActor(TargetActor)


	var arc_height = TargetActor.global_position.y - bullet.global_position.y - 32
	arc_height = min(arc_height, -32)
	var target_position = TargetActor.get_global_position()
	target_position += Vector2(rand_range(-15,15), 0)
	var toss_velocity = GlobalFunctions.calc_arc_velocity(bullet.global_position, target_position, arc_height, ProjectSettings.get_setting("physics/2d/default_gravity"))
	toss_velocity = toss_velocity.clamped(bullet.BaseSpeed * 2)
	bullet.set_linear_velocity(toss_velocity)
	
#	var vec: Vector2
#	vec = TargetActor.global_position - bullet.global_position
#	var angle = GlobalFunctions.optimal_angle(vec.x, vec.y, bullet.BaseSpeed, ProjectSettings.get_setting("physics/2d/default_gravity"))
#	var vel2 = Vector2.UP.rotated(angle) * bullet.BaseSpeed
#	bullet.set_linear_velocity(vel2)
	
	
	pass
