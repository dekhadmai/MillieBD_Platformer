extends "res://src/Ability/GameplayAbility_ActorSpawner.gd"

var bullet_spawner_component = null
var cache_rotation

func _ready():
	if bullet_spawner_component == null :
		bullet_spawner_component = find_node("BulletSpawnerComponent")
		
	bullet_spawner_component.Init(AbilityOwner, self, GameplayeEffect_Template)
	var _error = bullet_spawner_component.connect("OnSpawnBullet", self, "OnSpawnBullet")
	
func Activate():
	.Activate()
	cache_rotation = .GetSpawnRotation()
	
func GetSpawnRotation():
	return cache_rotation
	
func SpawnActor() -> void:
	bullet_spawner_component.SetHomeTargetActor(TargetActor)
	bullet_spawner_component.Activate()
	pass

func OnSpawnBullet(_bullet):
	# do nothing on the base class
	pass
