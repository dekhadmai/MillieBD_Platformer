class_name BulletSpawnerComponent
extends Position2D


export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

var SpawnRotation:Vector2 = Vector2(0,0)

var gameplay_effect_template
var Instigator:Actor

func GetOwnerObject() : 
	return GlobalFunctions.GetOwnerObject(self)

func Init(instigator:Actor, gameplayeffect_template:BaseGameplayEffect):
	Instigator = instigator
	gameplay_effect_template = gameplayeffect_template
	get_rotation()
