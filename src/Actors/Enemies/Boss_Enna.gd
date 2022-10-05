extends Enemy

var FeatherBeamTimer
var FeatherHomingTimer
var FullScreenTimer
onready var ability_feather_beam = $AbilitySystemComponent/Enna_FeatherBeam
onready var ability_feather_homing = $AbilitySystemComponent/Enna_FeatherHoming
onready var ability_fullscreen = $AbilitySystemComponent/Enna_FullScreen

var top_left: Vector2
var bottom_right: Vector2

func _ready():
	top_left = get_parent().find_node("Room_TopLeft").get_global_position()
	bottom_right = get_parent().find_node("Room_BottomRight").get_global_position()
	
	CurrentTargetActor = AutoLoadTransientData.player
	
	FeatherHomingTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherHoming_Timeout")
	FeatherHomingTimer.set_one_shot(false)
	FeatherHomingTimer.start(4)
	
	FeatherBeamTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherBeam_Timeout")
	FeatherBeamTimer.set_one_shot(false)
	FeatherBeamTimer.start(6)
	
	FullScreenTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FullScreen_Timeout")
	FullScreenTimer.set_one_shot(false)
	FullScreenTimer.start(20)
	

func _FeatherBeam_Timeout():
	if !ability_fullscreen.IsAbilityActive():
		ability_feather_beam.SetTargetActor(CurrentTargetActor)
		ability_feather_beam.TryActivate()

func _FeatherHoming_Timeout():
	if !ability_fullscreen.IsAbilityActive():
		ability_feather_homing.SetTargetActor(CurrentTargetActor)
		ability_feather_homing.TryActivate()

func _FullScreen_Timeout():
	ability_fullscreen.SetTargetActor(CurrentTargetActor)
	ability_fullscreen.TryActivate()
	FullScreenTimer.start(1)
