class_name AIControllerAerial
extends AIController

var TooClose:= false
onready var safe_distance = $SafeDistance
onready var movement_rays = $MovementRays

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SafeDistance_body_entered(body):
	print(body.name)
	if body.name == 'Player':
		TooClose = true

func _on_SafeDistance_body_exited(body):
	if body.name == 'Player':
		TooClose = false
		

func update_physics(delta):
	if PlayerDetected:
		kinematic_body.velocity = kinematic_body.position.direction_to(kinematic_body.CurrentTargetActor.position) * kinematic_body.speed.x
	else:
		kinematic_body.velocity = Vector2.ZERO;

func update_ray(delta):
	var closest_collision = null
	movement_rays.rotation += delta * 11 * PI
	
	for ray in movement_rays.get_children():
		var collision_point = ray.get_collision.point() - global_position
		if closest_collision == null:
			closest_collision = collision_point
		if collision_point.length() < closest_collision.length():
			closest_collision = collision_point
	
	#Handle collision detection here
	if closest_collision:
		pass
