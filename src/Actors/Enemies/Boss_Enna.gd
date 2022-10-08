extends Enemy

var FeatherBeamTimer
var FeatherHomingTimer
var FullScreenTimer
onready var ability_feather_beam = $AbilitySystemComponent/Enna_FeatherBeam
onready var ability_feather_homing = $AbilitySystemComponent/Enna_FeatherHoming
onready var ability_fullscreen = $AbilitySystemComponent/Enna_FullScreen

var top_left: Vector2
var bottom_right: Vector2

var AbilityLevel = 0

func _physics_process(delta):
	if ai_controller:
		ai_controller.update_physics(delta)
		
	if GetAbilitySystemComponent().CurrentCharStats.CurrentHP <= GetAbilitySystemComponent().CurrentCharStats.BaseHP / 2.0 and AbilityLevel == 0:
		EnterPhase(1)
		

func died():
	if AbilityLevel == 2:
		.died()
		return
		
	EnterPhase(2)

func EnterPhase(state_level):
	AbilityLevel = state_level
	ability_feather_beam.AbilityLevel = AbilityLevel
	ability_feather_homing.AbilityLevel = AbilityLevel
	ability_fullscreen.AbilityLevel = AbilityLevel
	if state_level == 2:
		GetAbilitySystemComponent().CurrentCharStats.CurrentHP = GetAbilitySystemComponent().CurrentCharStats.BaseHP
		

func _ready():
	ai_controller = get_parent().find_node("AIControllerAerial")
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
