extends KinematicBody2D

export(Array, Vector2) var MoveToPosition_Local
export(Array, float) var MoveToRotation_Local
export(Array, float) var MoveTo_Seconds
export var default_move_to_seconds = 3.0

var MoveToPosition = []
var MoveToRotation = []
var current_move_to_index = 0
var current_start_move_position: Vector2
var current_move_to_position: Vector2
var current_start_move_rotation: float
var current_move_to_rotation: float
var current_move_to_time: float = 0



var start_position: Vector2
var start_rotation: float
var tmp_moveto_seconds

func _ready():
	start_position = get_global_position()
	start_rotation = get_global_rotation()
	
	if MoveToPosition_Local.size() == 0 :
		return
	
	for i in MoveToPosition_Local.size():
		MoveToPosition.append(start_position + MoveToPosition_Local[i])
		MoveToRotation.append(start_rotation)
		
	for i in MoveToRotation_Local.size():
		MoveToRotation[i] = (start_rotation + deg2rad(MoveToRotation_Local[i]))
		
	current_move_to_index = 0
	current_move_to_position = MoveToPosition[current_move_to_index]
	current_move_to_rotation = MoveToRotation[current_move_to_index]
	current_start_move_position = get_global_position()
	current_start_move_rotation = get_global_rotation()

func _physics_process(delta):
	
	if MoveToPosition_Local.size() == 0 :
		return

	if MoveTo_Seconds.size() == 0:
		tmp_moveto_seconds = default_move_to_seconds
	else : 
		tmp_moveto_seconds = MoveTo_Seconds[current_move_to_index]
		if tmp_moveto_seconds == 0:
			tmp_moveto_seconds = default_move_to_seconds
	
	current_move_to_time += delta/tmp_moveto_seconds
	if current_move_to_time <= 1.0 :
		set_global_position(lerp(current_start_move_position, current_move_to_position, current_move_to_time))
		set_global_rotation(lerp(current_start_move_rotation, current_move_to_rotation, current_move_to_time))
	else:
		current_move_to_time = 0
		current_start_move_position = current_move_to_position
		current_start_move_rotation = current_move_to_rotation
		current_move_to_index = (current_move_to_index+1) % MoveToPosition.size()
		current_move_to_position = MoveToPosition[current_move_to_index]
		current_move_to_rotation = MoveToRotation[current_move_to_index]
		
