extends Enemy

var FeatherBeamTimer
var FeatherHomingTimer
onready var ability_feather_beam = $AbilitySystemComponent/Enna_FeatherBeam
onready var ability_feather_homing = $AbilitySystemComponent/Enna_FeatherHoming

func _ready():
	CurrentTargetActor = AutoLoadTransientData.player
	
	FeatherHomingTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherHoming_Timeout")
	FeatherHomingTimer.set_one_shot(false)
	FeatherHomingTimer.start(1)
	
	FeatherBeamTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_FeatherBeam_Timeout")
	FeatherBeamTimer.set_one_shot(false)
	FeatherBeamTimer.start(1)

func _FeatherBeam_Timeout():
	ability_feather_beam.SetTargetActor(CurrentTargetActor)
	ability_feather_beam.TryActivate()

func _FeatherHoming_Timeout():
	ability_feather_homing.SetTargetActor(CurrentTargetActor)
	ability_feather_homing.TryActivate()
