class_name AIControllerGrounded
extends AIController


onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
export var patrol_offset_x = 150
var bWalkLeft = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_physics(delta):
	
	if kinematic_body._velocity.x > 0 :
		bWalkLeft = false
	elif kinematic_body._velocity.x < 0 :
		bWalkLeft = true
	
	
	if bWalkLeft and (not floor_detector_left.is_colliding() or get_global_position().x <= starting_position.x-patrol_offset_x) : 
		kinematic_body._velocity.x = kinematic_body.speed.x
	elif !bWalkLeft and (not floor_detector_right.is_colliding() or get_global_position().x >= starting_position.x+patrol_offset_x) : 
		kinematic_body._velocity.x = -kinematic_body.speed.x
		

	if kinematic_body.is_on_wall() :
		kinematic_body._velocity.x *= -1
		
		
	.update_physics(delta)
