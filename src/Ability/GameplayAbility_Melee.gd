extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var CustomAnimName: String = "_weapon"
export var CustomAnimDuration: float = 0.3 



export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

export var GameplayEffectNodeName: String = "GameplayEffectTemplate"
onready var GameplayeEffect_Template: BaseGameplayEffect

onready var melee = preload("res://src/Objects/Base/BaseMelee.tscn")
var TargetActor:Actor = null setget SetTargetActor


func SetTargetActor(target:Actor):
	TargetActor = target

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
	if GameplayeEffect_Template == null:
		GameplayeEffect_Template = get_node(GameplayEffectNodeName)
	

func Activate():
	.Activate()
	
	print_debug('swing the f sword')

	melee.play('swing')
	#getAnim().PlayFullBodyAnim('swing', 1.0)

	EndAbility()
	pass
