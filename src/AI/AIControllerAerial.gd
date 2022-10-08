class_name AIControllerAerial
extends AIController

var tooClose:= false
var collisionAvoidanceDistance := 60
onready var safe_distance = $SafeDistance
onready var vision_rays = $VisionRays


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SafeDistance_body_entered(body):
	if body.name == 'Player':
		tooClose = true

func _on_SafeDistance_body_exited(body):
	if body.name == 'Player':
		tooClose = false

func update_physics(delta, hover = false):
	if PlayerDetected:
		FollowActor(kinematic_body.CurrentTargetActor)
		
		if hover and tooClose:
			StopMove()
	else:
		StopMove();
		
	.update_physics(delta)

func update_ray(movementDir: Vector2):
	vision_rays.angle = rad2deg(movementDir.angle())
	
	for ray in vision_rays.get_children():
		if ray.is_colliding():
			kinematic_body._velocity += ray.get_collision_normal() * collisionAvoidanceDistance

func FollowActor(target_actor: Actor) -> bool :
	FollowActorTarget = target_actor
	
	var movementDir := kinematic_body.global_position.direction_to(target_actor.global_position)
	var result = MoveTo(movementDir)
	
	# collision avoidance
	update_ray(movementDir)

	return result
