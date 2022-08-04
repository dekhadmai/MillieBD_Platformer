extends BaseGameplayAbility

const BULLET_VELOCITY = 500.0
export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

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
	
	var bullet = Bullet.instance()
	bullet.Init(AbilityOwner, GameplayeEffect_Template)
	bullet.global_position = SocketNode.global_position
	bullet.linear_velocity = Vector2(AbilityOwner.FacingDirection * BULLET_VELOCITY, 0)
	bullet.set_gravity_scale(0.0)

	bullet.set_as_toplevel(true)
	add_child(bullet)
	sound_shoot.play()
	
	PlayCustomAnimation("_weapon", 0.3)
	
	EndAbility()
	
	pass
