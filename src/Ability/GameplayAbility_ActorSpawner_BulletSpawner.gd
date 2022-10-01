extends "res://src/Ability/GameplayAbility_ActorSpawner.gd"

var bullet_spawner_component = null

func _ready():
	if bullet_spawner_component == null :
		bullet_spawner_component = get_node("BulletSpawnerComponent")
		
	bullet_spawner_component.Init(AbilityOwner, GameplayeEffect_Template)
	bullet_spawner_component.connect("OnSpawnBullet", self, "OnSpawnBullet")
	

func SpawnActor() -> void:
	bullet_spawner_component.SetHomeTargetActor(TargetActor)
	bullet_spawner_component.Activate()
	pass

func OnSpawnBullet(bullet):
	# do nothing on the base class
	pass
