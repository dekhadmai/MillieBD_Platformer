extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var CustomAnimName: String = "_weapon"
export var CustomAnimDuration: float = 0.1

export var LingeringAnimName: String = "_active_weapon"
export var LingeringAnimDuration: float = 1.0

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

var SpawnRotation:Vector2 = Vector2(0,0)

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
	

func Activate():
	.Activate()
	
	SpawnActor()
	ability_sound.play()
	PlayCustomAnimation(CustomAnimName, CustomAnimDuration)
	SetLingeringAnimation(LingeringAnimName, LingeringAnimDuration)
	
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
	var vec : Vector2
	
	if TargetActor:
		vec = (TargetActor.GetTargetingPosition() - GetSpawnPosition()).normalized()
	elif SpawnRotation != Vector2(0,0) :
		vec = SpawnRotation 
	else :
		vec = Vector2(AbilityOwner.FacingDirection, 0)
	
		if AbilityOwner is Player : 
			if Input.is_action_just_pressed("shoot") :
				if Input.is_action_pressed("move_up") :
					vec.x = 0.0
					vec.y -= 1.0
				if Input.is_action_pressed("move_down") :
					vec.x = 0.0
					vec.y += 1.0
		
	return vec
