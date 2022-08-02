extends BaseGameplayAbility

const BULLET_VELOCITY = 500.0
const Bullet = preload("res://src/Objects/Bullet.tscn")

onready var sound_shoot = $Shoot

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
	

func Activate():
	.Activate()
	
	var bullet = Bullet.instance()
	AbilityOwner.find_node("")
	bullet.global_position = SocketNode.global_position
	bullet.linear_velocity = Vector2(AbilityOwner.FacingDirection * BULLET_VELOCITY, 0)
	bullet.set_gravity_scale(0.0)

	bullet.set_as_toplevel(true)
	add_child(bullet)
	sound_shoot.play()
	
	
	EndAbility()
	
	pass
