extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var CustomAnimName: String = "_weapon"
export var CustomAnimDuration: float = 0.3 



export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

onready var melee = preload("res://src/Objects/Base/BaseMelee.tscn")
var melee_instance


func _ready():
	melee_instance = melee.instance()
	add_child(melee_instance)

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
	

func Activate():
	.Activate()
	
	print_debug('swing the f sword')

	melee_instance.play("swing")
	#getAnim().PlayFullBodyAnim('swing', 1.0)

	EndAbility()
	pass
