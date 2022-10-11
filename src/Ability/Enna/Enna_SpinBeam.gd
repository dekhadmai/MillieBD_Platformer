extends "res://src/Ability/Base/GameplayAbility_AreaDetection.gd"

onready var AnchorNode = $Anchor
var SpinActiveTimer:Timer

onready var hurt_detection1: Area2D = $Anchor/Area2D_Damage_Telegraph1
onready var hurt_detection2: Area2D = $Anchor/Area2D_Damage_Telegraph2
onready var hurt_detection3: Area2D = $Anchor/Area2D_Damage_Telegraph3
onready var hurt_detection4: Area2D = $Anchor/Area2D_Damage_Telegraph4

export var Spin_TelegraphDuration: float = 4.00
export var Spin_LingerDuration: float = 7.95
export var Spin_ReactivateDuration: float = 8.00
export var Spin_DegreePerSecond: float = 15

func update_physics(delta):
	AnchorNode.rotate(deg2rad(Spin_DegreePerSecond * delta))
	pass

func InitHurtDetection(hurt_detection_local):
	hurt_detection_local.connect("OnHurtDetection", self, "OnHurtDetectionHit")
	hurt_detection_local.TelegraphAnimDuration = Spin_TelegraphDuration
	hurt_detection_local.AreaLingerDuration = Spin_LingerDuration

func Init():
	.Init()
	
	hurt_detection1 = find_node("Area2D_Damage_Telegraph1")
	hurt_detection2 = find_node("Area2D_Damage_Telegraph2")
	hurt_detection3 = find_node("Area2D_Damage_Telegraph3")
	hurt_detection4 = find_node("Area2D_Damage_Telegraph4")
	
	InitHurtDetection(hurt_detection1)
	InitHurtDetection(hurt_detection2)
	InitHurtDetection(hurt_detection3)
	InitHurtDetection(hurt_detection4)
	hurt_detection1.connect("OnEndAreaLinger", self, "_on_Area2D_Damage_OnEndAreaLinger")
	
	SpinActiveTimer = GlobalFunctions.CreateTimerAndBind(self, self, "SpinActive_Timeout")
	SpinActiveTimer.set_one_shot(true)
	
func SpinActive_Timeout():
	Activate()

func Activate():
	.Activate()
	SpinActiveTimer.start(Spin_ReactivateDuration)
	
	hurt_detection1.SetActive(true)
	hurt_detection2.SetActive(true)
	hurt_detection3.SetActive(true)
	hurt_detection4.SetActive(true)

func ForceEndAbility():
	EndAbility()
	SpinActiveTimer.stop()
	
	
