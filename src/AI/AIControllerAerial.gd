class_name AIControllerAerial
extends AIController

export var bUseHover = true
var tooClose:= false
onready var safe_distance = $SafeDistance
onready var vision_rays = $VisionRays


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SafeDistance_body_entered(body):
	if body.GetTeam() != kinematic_body.GetTeam():
		tooClose = true

func _on_SafeDistance_body_exited(body):
	if body.GetTeam() != kinematic_body.GetTeam():
		tooClose = false

func update_physics(delta):
	if PlayerDetected:
		if bUseFollowActor or bUseFollowPosition :
			FollowActor()
			FollowPosition()
		else:
			StopMove()
		
		if bUseHover and tooClose:
			StopMove()
	else:
		StopMove();
		
	# collision avoidance
	update_ray(move_direction)
	
	.update_physics(delta)

func update_ray(movementDir: Vector2):
	vision_rays.set_global_rotation(movementDir.angle())
	
	for ray in vision_rays.get_children():
		if ray.is_colliding():
			kinematic_body._velocity += ray.get_collision_normal() * kinematic_body.speed.x
