extends BaseGameplayAbility

export var bEndAbilityAfterActivate = true
export var bUseSetAsTopLevel = true
export(String, FILE, "*.tscn") var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

var SpawnRotation:Vector2 = Vector2(0,0)

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
	

func DoAbility():
	.DoAbility()
	
	SpawnActor()
	
	if bEndAbilityAfterActivate : 
		EndAbility()
	pass

func SpawnActor() -> void:
	var bullet = Bullet.instance()
	
	bullet.set_as_toplevel(bUseSetAsTopLevel)
	add_child(bullet)
	
	bullet.global_position = GetSpawnPosition()
	var velocity = GetSpawnRotation()
	bullet.set_global_rotation(velocity.angle())
	bullet.Init(AbilityOwner, self, GameplayeEffect_Template)
	bullet.SetHomeTargetActor(TargetActor)

func GetSpawnPosition() -> Vector2:
	return SocketNode.global_position
	
func GetSpawnRotation() -> Vector2:
	var vec : Vector2
	
	if is_instance_valid(TargetActor):
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
