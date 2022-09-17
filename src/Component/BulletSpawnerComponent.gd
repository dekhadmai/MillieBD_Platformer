class_name BulletSpawnerComponent
extends Position2D


export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

var SpawnRotation:Vector2 = Vector2(0,0)


func GetOwnerObject() : 
	return GlobalFunctions.GetOwnerObject(self)

func Init():
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
