class_name AIControllerGrounded
extends AIController


onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
export var patrol_offset_x = 150
var start_position_x: float
var bWalkLeft = true


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position_x = get_global_position().x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_physics(delta):
	if not floor_detector_left.is_colliding():
		kinematic_body._velocity.x = kinematic_body.speed.x
		bWalkLeft = false
	elif not floor_detector_right.is_colliding():
		kinematic_body._velocity.x = -kinematic_body.speed.x
		bWalkLeft = true

	if kinematic_body.is_on_wall() :
		kinematic_body._velocity.x *= -1
		
	if get_global_position().x <= start_position_x-patrol_offset_x : 
		kinematic_body._velocity.x = kinematic_body.speed.x
		bWalkLeft = false
	elif get_global_position().x >= start_position_x+patrol_offset_x : 
		kinematic_body._velocity.x = -kinematic_body.speed.x
		bWalkLeft = true
		
	.update_physics(delta)
