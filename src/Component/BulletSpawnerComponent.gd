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
		
	if get_parent().has_method("GetSpawnPosition") :
		return get_parent().GetSpawnPosition()
		
	return .get_global_position()
	
func get_global_rotation()->float:
	if get_parent().has_method("GetSpawnRotation") :
		return get_parent().GetSpawnRotation().angle()
	return .get_global_rotation()
	pass

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
		var _error = bullet_spawn_data_array[i].connect("OnSpawnBullet", self, "OnSpawnBullet")


func OnSpawnBullet(bullet):
	emit_signal("OnSpawnBullet", bullet)
	pass
