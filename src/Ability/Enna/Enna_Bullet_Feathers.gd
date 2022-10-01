extends BaseBullet

export var first_stop_seconds = 0.2
export var second_move_seconds = 1.5
export var second_move_speed = 600.0

var first_stop_timer
var second_move_timer
var bRotateToTarget = false

func _ready():
	first_stop_timer = GlobalFunctions.CreateTimerAndBind(self, self, "_first_stop_timeout")
	first_stop_timer.start(first_stop_seconds)
	pass

func _physics_process(delta):
	if bRotateToTarget :
		set_global_rotation(movement_component.HomeTargetActor.GetTargetingPosition().angle_to_point(get_global_position()))
	pass


func _first_stop_timeout():
	movement_component.SetSpeed(0,0)
	bRotateToTarget = true
	second_move_timer = GlobalFunctions.CreateTimerAndBind(self, self, "_second_move_timeout")
	second_move_timer.start(second_move_seconds)

func _second_move_timeout():
	bRotateToTarget = false
	movement_component.SetSpeed(second_move_speed,second_move_speed)
	movement_component.Init()
	pass
