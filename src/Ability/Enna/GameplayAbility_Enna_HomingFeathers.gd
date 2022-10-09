extends "res://src/Ability/GameplayAbility_ActorSpawner_BulletSpawner.gd"

var bullet_spawner_comp_array = []
var bullet_spawner_component1 = null
var bullet_spawner_component2 = null
var bullet_spawner_component3 = null

var move_offset_sec = 0

func _ready():
	if bullet_spawner_component1 == null :
		bullet_spawner_component1 = get_node("BulletSpawnerComponent")
		
	if bullet_spawner_component2 == null :
		bullet_spawner_component2 = get_node("BulletSpawnerComponent2")
		
	if bullet_spawner_component3 == null :
		bullet_spawner_component3 = get_node("BulletSpawnerComponent3")
		
	bullet_spawner_component1.Init(AbilityOwner, self, GameplayeEffect_Template)
	bullet_spawner_component2.Init(AbilityOwner, self, GameplayeEffect_Template)
	bullet_spawner_component3.Init(AbilityOwner, self, GameplayeEffect_Template)
	
	bullet_spawner_component1.connect("OnSpawnBullet", self, "OnSpawnBullet")
	bullet_spawner_component2.connect("OnSpawnBullet", self, "OnSpawnBullet")
	bullet_spawner_component3.connect("OnSpawnBullet", self, "OnSpawnBullet")
	
	bullet_spawner_comp_array.append(bullet_spawner_component1)
	bullet_spawner_comp_array.append(bullet_spawner_component3)
	bullet_spawner_comp_array.append(bullet_spawner_component2)

func SpawnActor() -> void:
	bullet_spawner_component = bullet_spawner_comp_array[AbilityLevel]
	move_offset_sec = 0.0
	#AbilityLevel += 1
	#AbilityLevel = AbilityLevel % bullet_spawner_comp_array.size()
	.SpawnActor()

func OnSpawnBullet(bullet):
	if bullet_spawner_component == bullet_spawner_component3 :
		bullet.second_move_seconds = 1.5 + move_offset_sec
		move_offset_sec += 0.2
		
	if bullet_spawner_component == bullet_spawner_component2 :
		bullet.second_move_speed = 300
		bullet.GetMovementComponent().HomingStrength = 600
	pass
