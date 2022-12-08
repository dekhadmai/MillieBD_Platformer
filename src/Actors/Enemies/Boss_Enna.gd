extends Enemy

var RandomLocationTimer
var RandomLocationRadiusFromPlayer = 300
var RandomLocationInterval = 6.0
var RandomLocationEdgeOffset = 100.0

var Phase2_MoveSpeedScale = 5.0
var Phase2_RandomLocationInterval = 4.0

var FeatherHomingTimer
var FeatherBouncingTimer
var FeatherBeamTimer
var FullScreenTimer
var SpinBeamTimer
var FeatherHomingInterval = 4.0
var FeatherBouncingInterval = 10.0
var FeatherBeamInterval = 6.0
var FullScreenInterval = 15.0
var SpinBeamInterval = 1.0
onready var ability_feather_beam = $AbilitySystemComponent/Enna_FeatherBeam
onready var ability_feather_homing = $AbilitySystemComponent/Enna_FeatherHoming
onready var ability_feather_bouncing = $AbilitySystemComponent/Enna_FeatherBouncing
onready var ability_fullscreen = $AbilitySystemComponent/Enna_FullScreen
onready var ability_groundbeam = $AbilitySystemComponent/Enna_GroundBeam
onready var ability_spinbeam = $AbilitySystemComponent/Enna_SpinBeam

onready var audio_phase1:AudioStreamPlayer = $EnnaPhase1
onready var audio_phase2:AudioStreamPlayer = $EnnaPhase2

var StunnedTimer

var top_left: Vector2
var bottom_right: Vector2

var AbilityLevel = 0
var bIsStunned = false
var StunDuration = 5.0
var bIsTransform = false

var HomingFeatherChance = 0.5

export var StunnedAnimName = "stunned"

func _physics_process(delta):
	
	if bIsTransform :
		GetAbilitySystemComponent().CurrentCharStats.CurrentHP += GetAbilitySystemComponent().CurrentCharStats.BaseHP / (1.0/delta)
	
	var abi_comp = GetAbilitySystemComponent()
	if abi_comp :
		var str_value = "Enna Alouette : " + str("%.0f" % abi_comp.CurrentCharStats.CurrentHP) + "/" + str(abi_comp.CurrentCharStats.BaseHP)
		$CanvasLayer/Boss_Hpbar.set_max(abi_comp.CurrentCharStats.BaseHP)
		$CanvasLayer/Boss_Hpbar.set_value(abi_comp.CurrentCharStats.CurrentHP)
		$CanvasLayer/Boss_Hpbar/Boss_Hpvalue.set_text(str_value)
		
	if ai_controller:
		if ability_fullscreen.IsAbilityActive() or bIsStunned:
			ai_controller.bUseFollowPosition = false
		else:
			ai_controller.bUseFollowPosition = true
			
		ai_controller.update_physics(delta)
		
	if GetAbilitySystemComponent().CurrentCharStats.CurrentHP <= GetAbilitySystemComponent().CurrentCharStats.BaseHP / 2.0 and AbilityLevel == 0:
		EnterPhase(1)
		

func UpdateAnimState():
	if !bIsStunned or _state == State.DEAD :
		.UpdateAnimState()
	else:
		if animation_player != null : 
			animation_player.BaseAnimState = StunnedAnimName

func Stun():
	bIsStunned = true
	FeatherHomingTimer.stop()
	FeatherBeamTimer.stop()
	FullScreenTimer.stop()
	SpinBeamTimer.stop()
	StunnedTimer.start(StunDuration)

func UnStun():
	ability_feather_homing.SetTargetActor(CurrentTargetActor)
	ability_feather_homing.TryActivate()

	FeatherHomingTimer.start(FeatherHomingInterval)
	FeatherBeamTimer.start(FeatherBeamInterval)
	FullScreenTimer.start(FullScreenInterval)
	SpinBeamTimer.start(SpinBeamInterval)

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
	ability_feather_bouncing.AbilityLevel = AbilityLevel
	ability_fullscreen.AbilityLevel = AbilityLevel
	ability_spinbeam.AbilityLevel = AbilityLevel
	
	if state_level == 1:
		DialogEnna(1)
		ActivateGroundBeam()
	
	if state_level == 2:
		DialogEnna(2)
		
		Transformation()
	
	else : 
		UnStun()
		
		
func Transformation() : 
	GetAbilitySystemComponent().CurrentCharStats.bInvincible += 1
	animation_player.PlayFullBodyAnim("ascend", 1.0)
	
	
	$TransformTimer/TransformAnim1.start(1.0)
	

func _on_TransformAnim1_timeout():
	#autoload_mapdata.PlaySfx("EnnaBitch")
	animation_player.PlayFullBodyAnim("transformation", 1.0)
	bIsTransform = true
	$TransformTimer.start(1.0)
	
func TransformationEndTimer() : 
	bIsTransform = false
	GetAbilitySystemComponent().CurrentCharStats.CurrentHP = GetAbilitySystemComponent().CurrentCharStats.BaseHP
	GetAbilitySystemComponent().CurrentCharStats.SetMovespeedScale(Phase2_MoveSpeedScale)
	GetAbilitySystemComponent().CurrentCharStats.SetDamageAdjustScale(1.25)
	RandomLocationInterval = Phase2_RandomLocationInterval
	StunDuration = 5.0
	
	FeatherHomingInterval = 6.0
#	FeatherBouncingInterval = 6.0
	FeatherBeamInterval = 8.0
	HomingFeatherChance = 0.10
	
	audio_phase1.stop()
	audio_phase2.play()
	
	IdleAnimName += "_angry"
	WalkAnimName += "_angry"
	
	ability_feather_beam.FullbodyAnimName += "_angry"
	ability_feather_homing.FullbodyAnimName += "_angry"
	ability_feather_bouncing.FullbodyAnimName += "_angry"
	
	GetAbilitySystemComponent().CurrentCharStats.bInvincible = 0
	
	UnStun()

func ActivateGroundBeam():	
	ability_groundbeam.TryActivate()

func _ready():
	top_left = get_parent().find_node("Room_TopLeft").get_global_position()
	bottom_right = get_parent().find_node("Room_BottomRight").get_global_position()
	
	CurrentTargetActor = AutoLoadTransientData.player
	
	FeatherHomingTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherHoming_Timeout")
	FeatherHomingTimer.set_one_shot(false)
	FeatherHomingTimer.start(FeatherHomingInterval)
	
	FeatherBouncingTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherBouncing_Timeout")
	FeatherBouncingTimer.set_one_shot(false)
	#FeatherBouncingTimer.start(FeatherBouncingInterval)
	
	FeatherBeamTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherBeam_Timeout")
	FeatherBeamTimer.set_one_shot(false)
	FeatherBeamTimer.start(FeatherBeamInterval)
	
	FullScreenTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FullScreen_Timeout")
	FullScreenTimer.set_one_shot(false)
	FullScreenTimer.start(FullScreenInterval)
	
	SpinBeamTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_SpinBeam_Timeout")
	SpinBeamTimer.set_one_shot(false)
	SpinBeamTimer.start(SpinBeamInterval)
	
	
	ai_controller.SetFollowPosition(get_global_position())
	RandomLocationTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_PickMoveToRandomLocation")
	RandomLocationTimer.set_one_shot(true)
	RandomLocationTimer.start(RandomLocationInterval)
	
	StunnedTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_Stunned_Timeout")
	StunnedTimer.set_one_shot(true)
	
#	FeatherHomingTimer.stop()
#	FeatherBeamTimer.stop()
#	FullScreenTimer.stop()
#	SpinBeamTimer.stop()
#
#	SpinBeamTimer.start(SpinBeamInterval)
#	ability_spinbeam.AbilityLevel = 2
#	AbilityLevel = 2

func _PickMoveToRandomLocation():
	var location:Vector2 = Vector2.ZERO
	location.x = CurrentTargetActor.get_global_position().x + rand_range(0, RandomLocationRadiusFromPlayer) - (RandomLocationRadiusFromPlayer/2)
	location.y = CurrentTargetActor.get_global_position().y + rand_range(0, RandomLocationRadiusFromPlayer) - (RandomLocationRadiusFromPlayer/2)
	location.x = clamp(location.x, top_left.x+RandomLocationEdgeOffset, bottom_right.x-RandomLocationEdgeOffset)
	location.y = clamp(location.y, top_left.y+RandomLocationEdgeOffset, bottom_right.y-RandomLocationEdgeOffset)
	ai_controller.SetFollowPosition(location)
	
	RandomLocationTimer.start(RandomLocationInterval)

func _FeatherBeam_Timeout():
	if !ability_fullscreen.IsAbilityActive():
		ability_feather_beam.SetTargetActor(CurrentTargetActor)
		ability_feather_beam.TryActivate()

func _FeatherHoming_Timeout():
	if !ability_fullscreen.IsAbilityActive():
		if randf() < HomingFeatherChance:
			ability_feather_homing.SetTargetActor(CurrentTargetActor)
			ability_feather_homing.TryActivate()
		else:
			ability_feather_bouncing.SetTargetActor(CurrentTargetActor)
			ability_feather_bouncing.TryActivate()
		
func _FeatherBouncing_Timeout():
	if !ability_fullscreen.IsAbilityActive():
		ability_feather_bouncing.SetTargetActor(CurrentTargetActor)
		ability_feather_bouncing.TryActivate()

func _FullScreen_Timeout():
	ability_fullscreen.SetTargetActor(CurrentTargetActor)
	ability_fullscreen.TryActivate()
	
	FullScreenTimer.start(1)

func _SpinBeam_Timeout():
	if AbilityLevel == 2 : 
		if !ability_fullscreen.IsAbilityActive():
			ability_spinbeam.SetTargetActor(CurrentTargetActor)
			ability_spinbeam.TryActivate()
		else:
			ability_spinbeam.ForceEndAbility()

func queue_free() : 
	AfterDeathAnim()
	
#	DialogEnna(3)
#	var delay_death = GlobalFunctions.CreateTimerAndBind(self, self, "DelayDeath")
#	delay_death.start(0.1)
	



#func DelayDeath() : 
#	.queue_free()
	
func AfterDeathAnim() : 
	StunDuration = 999999
	StunnedAnimName = "idle_haloless"
	Stun()
	DialogEnna(3)
	$CanvasLayer/Boss_Hpbar.hide()
	ability_spinbeam.queue_free()
	ability_groundbeam.queue_free()
	animation_player.PlayFullBodyAnim("idle_haloless", 999999)
	
	AutoLoadTransientData.exit_door.SetActive(true)

##### dialog stuff
func DialogEnna(phase_number):
	GlobalSettings.dialog_test_up = true
	GlobalSettings.dialog_reset = false
	if phase_number == 0 :
		get_node("DialogLayer/Enna_DialogPlayer1/Dialog").dialog_file = "res://src/UserInterface/Dialog/DialogData/DialogEnna1.tres"
	elif phase_number == 1 :
		get_node("DialogLayer/Enna_DialogPlayer1/Dialog").dialog_file = "res://src/UserInterface/Dialog/DialogData/DialogEnna2.tres"
	elif phase_number == 2 :
		get_node("DialogLayer/Enna_DialogPlayer1/Dialog").dialog_file = "res://src/UserInterface/Dialog/DialogData/DialogEnna3.tres"
	elif phase_number == 3 :
		get_node("DialogLayer/Enna_DialogPlayer1/Dialog").dialog_file = "res://src/UserInterface/Dialog/DialogData/DialogEnna4.tres"
	
	get_node("DialogLayer/Enna_DialogPlayer1/Dialog").init()
	get_node("DialogLayer/Enna_DialogPlayer1/DialogControl").init()
	get_node("DialogLayer/Enna_DialogPlayer1").show()
	get_node("DialogLayer/Enna_DialogPlayer1/DialogControl").show_dialog()
	get_tree().paused = true


func _on_FirstDialogTimer_timeout():
	DialogEnna(0)



