extends Enemy

var RandomLocationTimer
var RandomLocationRadiusFromPlayer = 300
var RandomLocationInterval = 6.0

var Phase2_MoveSpeedScale = 5.0
var Phase2_RandomLocationInterval = 4.0

var FeatherHomingTimer
var FeatherBeamTimer
var FullScreenTimer
var FeatherHomingInterval = 4.0
var FeatherBeamInterval = 6.0
var FullScreenInterval = 15.0
onready var ability_feather_beam = $AbilitySystemComponent/Enna_FeatherBeam
onready var ability_feather_homing = $AbilitySystemComponent/Enna_FeatherHoming
onready var ability_fullscreen = $AbilitySystemComponent/Enna_FullScreen

var StunnedTimer

var top_left: Vector2
var bottom_right: Vector2

var AbilityLevel = 0
var bIsStunned = false
var StunDuration = 5.0

func _physics_process(delta):
	if ai_controller:
		if ability_fullscreen.IsAbilityActive() or bIsStunned:
			ai_controller.bUseFollowPosition = false
		else:
			ai_controller.bUseFollowPosition = true
			
		ai_controller.update_physics(delta)
		
	if GetAbilitySystemComponent().CurrentCharStats.CurrentHP <= GetAbilitySystemComponent().CurrentCharStats.BaseHP / 2.0 and AbilityLevel == 0:
		EnterPhase(1)
		

func UpdateAnimState():
	if !bIsStunned :
		.UpdateAnimState()
	else:
		if animation_player != null : 
			animation_player.BaseAnimState = "cast"

func Stun():
	bIsStunned = true
	FeatherHomingTimer.stop()
	FeatherBeamTimer.stop()
	FullScreenTimer.stop()
	StunnedTimer.start(StunDuration)

func UnStun():
	_FeatherHoming_Timeout()
	FeatherHomingTimer.start(FeatherHomingInterval)
	FeatherBeamTimer.start(FeatherBeamInterval)
	FullScreenTimer.start(FullScreenInterval)
	bIsStunned = false
	
func _Stunned_Timeout():
	UnStun()

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
		GetAbilitySystemComponent().CurrentCharStats.SetMovespeedScale(Phase2_MoveSpeedScale)
		RandomLocationInterval = Phase2_RandomLocationInterval
		StunDuration = 8.0
		
	UnStun()

func _ready():
	top_left = get_parent().find_node("Room_TopLeft").get_global_position()
	bottom_right = get_parent().find_node("Room_BottomRight").get_global_position()
	
	CurrentTargetActor = AutoLoadTransientData.player
	
	FeatherHomingTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherHoming_Timeout")
	FeatherHomingTimer.set_one_shot(false)
	FeatherHomingTimer.start(FeatherHomingInterval)
	
	FeatherBeamTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherBeam_Timeout")
	FeatherBeamTimer.set_one_shot(false)
	FeatherBeamTimer.start(FeatherBeamInterval)
	
	FullScreenTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FullScreen_Timeout")
	FullScreenTimer.set_one_shot(false)
	FullScreenTimer.start(FullScreenInterval)
	
	ai_controller.SetFollowPosition(get_global_position())
	RandomLocationTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_PickMoveToRandomLocation")
	RandomLocationTimer.set_one_shot(true)
	RandomLocationTimer.start(RandomLocationInterval)
	
	StunnedTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_Stunned_Timeout")
	StunnedTimer.set_one_shot(true)

func _PickMoveToRandomLocation():
	var location:Vector2 = Vector2.ZERO
	location.x = CurrentTargetActor.get_global_position().x + rand_range(0, RandomLocationRadiusFromPlayer) - (RandomLocationRadiusFromPlayer/2)
	location.y = CurrentTargetActor.get_global_position().y + rand_range(0, RandomLocationRadiusFromPlayer) - (RandomLocationRadiusFromPlayer/2)
	ai_controller.SetFollowPosition(location)
	
	RandomLocationTimer.start(RandomLocationInterval)

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
