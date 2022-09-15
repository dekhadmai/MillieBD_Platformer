class_name AIController
extends Node2D


var kinematic_body: Actor
var PlayerDetected:= false
onready var detection_range = $DetectionRange

var FollowActorTarget: Actor = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(kinematic: Actor):
	kinematic_body = kinematic

func _on_DetectionRange_body_entered(body):
	if body.name == 'Player':
		PlayerDetected = true


func _on_DetectionRange_body_exited(body):
	if body.name == 'Player':
		PlayerDetected = false

func update_physics(delta):
	kinematic_body._velocity.y = kinematic_body.move_and_slide(kinematic_body._velocity, kinematic_body.FLOOR_NORMAL).y
	pass
	
func MoveTo(target_position: Vector2) -> bool :
	# more implementation here
	return true
	
func FollowActor(target_actor: Actor) -> bool :
	FollowActorTarget = target_actor
	# more implementation here
	return true
	
func StopMove() -> bool : 
	# more implementation here
	return true
	
