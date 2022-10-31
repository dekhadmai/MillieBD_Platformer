extends "res://src/Ability/GameplayAbility_ActorSpawner_BulletSpawner.gd"


var bullet_count = 5
var bullet_rotation_range = 15
var bullet_spawn_delay_range = 0.1

var cache_rotation

func Activate():
	.Activate()
	cache_rotation = .GetSpawnRotation()
	
func SpawnActor() -> void:
	GlobalFunctions.queue_free_children(bullet_spawner_component)
	for i in bullet_count : 
		var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
		bullet_data.BulletData_Rotation = rand_range(-bullet_rotation_range, bullet_rotation_range)
		bullet_data.BulletData_Delay = rand_range(0.01, bullet_spawn_delay_range)
		bullet_spawner_component.add_child(bullet_data)
	
	.SpawnActor()

func GetSpawnRotation():
	return cache_rotation
