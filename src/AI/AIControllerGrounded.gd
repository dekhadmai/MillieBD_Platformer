class_name AIControllerGrounded
extends AIController


onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_physics(delta):
	if not floor_detector_left.is_colliding():
		kinematic_body._velocity.x = kinematic_body.speed.x
	elif not floor_detector_right.is_colliding():
		kinematic_body._velocity.x = -kinematic_body.speed.x

	if kinematic_body.is_on_wall():
		kinematic_body._velocity.x *= -1
		
	.update_physics(delta)
