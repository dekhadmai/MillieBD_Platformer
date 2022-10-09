class_name BulletSpawnerComponent
extends Position2D

signal OnSpawnBullet(bullet)

export(String, FILE, "*.tscn") var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

var SpawnRotation:Vector2 = Vector2(0,0)
var bullet_spawner_data: BulletSpawnerData

var gameplay_effect_template
var Instigator:Actor
var OwningAbility

var TargetActor = null
var TargetLocation = Vector2.ZERO

var bUseOverrideGlobalPosition = false
var OverrideGlobalPosition = Vector2.ZERO

func get_global_position()->Vector2:
	if bUseOverrideGlobalPosition:
		return OverrideGlobalPosition
		
	return .get_global_position()

func GetOwnerObject() : 
	return GlobalFunctions.GetOwnerObject(self)
	
func SetHomeTargetActor(target):
	TargetActor = target

func Init(instigator:Actor, owning_ability, gameplayeffect_template:BaseGameplayEffect):
	Instigator = instigator
	OwningAbility = owning_ability
	gameplay_effect_template = gameplayeffect_template

func Activate():
	var bullet_spawn_data_array = get_children()
	
	for i in bullet_spawn_data_array.size():
		bullet_spawn_data_array[i].Init()
		bullet_spawn_data_array[i].connect("OnSpawnBullet", self, "OnSpawnBullet")


func OnSpawnBullet(bullet):
	emit_signal("OnSpawnBullet", bullet)
	pass
