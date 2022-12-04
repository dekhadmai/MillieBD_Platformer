extends "res://src/Ability/GameplayAbility_ActorSpawner_BulletSpawner.gd"

var bullet_spawner_comp_array = []
var bullet_spawner_component1 = null

var move_offset_sec = 0

func _ready():
	if bullet_spawner_component1 == null :
		bullet_spawner_component1 = get_node("BulletSpawnerComponent")
		
	bullet_spawner_component1.Init(AbilityOwner, self, GameplayeEffect_Template)
	var _error = bullet_spawner_component1.connect("OnSpawnBullet", self, "OnSpawnBullet")
	
	bullet_spawner_comp_array.append(bullet_spawner_component1)

func SpawnActor() -> void:
	bullet_spawner_component = bullet_spawner_comp_array[0]
	.SpawnActor()

func OnSpawnBullet(bullet):
	if AbilityLevel == 1:
		bullet.BounceMaxCount = 3
		
	if AbilityLevel == 2:
		bullet.BounceMaxCount = 5
		#bullet.movement_component.SetSpeed(300,300)
		
	pass
