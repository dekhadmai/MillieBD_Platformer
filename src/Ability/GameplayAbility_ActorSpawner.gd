extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var CustomAnimName: String = "_weapon"
export var CustomAnimDuration: float = 0.3 

onready var sound_shoot = $Shoot

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

export var GameplayEffectNodeName: String = "GameplayEffectTemplate"
onready var GameplayeEffect_Template: BaseGameplayEffect

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
	if GameplayeEffect_Template == null:
		GameplayeEffect_Template = get_node(GameplayEffectNodeName)
	

func Activate():
	.Activate()
	
	SpawnActor()
	sound_shoot.play()
	PlayCustomAnimation(CustomAnimName, CustomAnimDuration)
	
	EndAbility()
	pass

func SpawnActor() -> void:
	var bullet = Bullet.instance()
	bullet.Init(AbilityOwner, GameplayeEffect_Template)
	bullet.global_position = GetSpawnPosition()
	var velocity = GetSpawnRotation()
	velocity *= bullet.BaseSpeed
	bullet.linear_velocity = velocity

	bullet.set_as_toplevel(true)
	add_child(bullet)
	pass

func GetSpawnPosition() -> Vector2:
	return SocketNode.global_position
	
func GetSpawnRotation() -> Vector2:
	return Vector2(AbilityOwner.FacingDirection, 0)
