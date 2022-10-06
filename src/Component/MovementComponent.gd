class_name MovementComponent
extends Node2D

export var bUseHoming: bool
export var HomingStrength: float = 300.0
var Speed: float = 300.0
var MaxSpeed: float = 300.0

var HomeTargetLocation = Vector2.ZERO
var HomeTargetActor = null

var OwnerActor

func Init() : 
	OwnerActor = GlobalFunctions.GetOwnerObject(self)
	var velocity_direction = GlobalFunctions.RotationToVector(OwnerActor.get_global_rotation())
	OwnerActor.set_linear_velocity(velocity_direction * Speed)

func SetSpeed(speed, max_speed):
	Speed = speed
	MaxSpeed = max_speed

func SetHomeTargetActor(target):
	HomeTargetActor = target
	
func SetHomeTargetLocation(location):
	HomeTargetLocation = location
	
func HomeStrength() -> Vector2 :
	var steer = Vector2.ZERO
	var target_position = Vector2.ZERO
	if bUseHoming : 
		if is_instance_valid(HomeTargetActor) : 
			target_position = HomeTargetActor.GetTargetingPosition()
		elif HomeTargetLocation != Vector2.ZERO:
			target_position = HomeTargetLocation
			
		var desired = (target_position - OwnerActor.global_position).normalized() * Speed
		steer = (desired - OwnerActor.get_linear_velocity()).normalized() * HomingStrength
	return steer

func _physics_process(delta):
	if bUseHoming : 
		var new_velocity:Vector2 = OwnerActor.get_linear_velocity() + (HomeStrength()*delta)
		new_velocity = new_velocity.normalized() * Speed
		#new_velocity.clamped(MaxSpeed)
		OwnerActor.set_linear_velocity(new_velocity)
