extends "res://src/Ability/Base/GameplayAbility_AreaDetection.gd"

onready var AnchorNode = $Anchor
var SpinActiveTimer:Timer

onready var hurt_detection1: Area2D = $Anchor/Area2D_Damage_Telegraph1
onready var hurt_detection2: Area2D = $Anchor/Area2D_Damage_Telegraph2
onready var hurt_detection3: Area2D = $Anchor/Area2D_Damage_Telegraph3
onready var hurt_detection4: Area2D = $Anchor/Area2D_Damage_Telegraph4

export var Spin_TelegraphDuration: float = 4.00
export var Spin_LingerDuration: float = 7.00
export var Spin_ReactivateDuration: float = 8.00
export var Spin_DegreePerSecond: float = 15

export var RandomRadius = 50
export var InnerRadius = 150

export var bTargetSelf = false

export var bUseTopLeftBottomRight = true
var top_left
var bottom_right

func update_physics(delta):
	AnchorNode.rotate(deg2rad(Spin_DegreePerSecond * delta))
	pass

func InitHurtDetection(hurt_detection_local):
	var _error = hurt_detection_local.connect("OnHurtDetection", self, "OnHurtDetectionHit")
	hurt_detection_local.TelegraphAnimDuration = Spin_TelegraphDuration
	hurt_detection_local.AreaLingerDuration = Spin_LingerDuration

func Init():
	.Init()
	
	if bUseTopLeftBottomRight : 
		top_left = AbilityOwner.get_parent().find_node("Room_TopLeft").get_global_position()
		bottom_right = AbilityOwner.get_parent().find_node("Room_BottomRight").get_global_position()
	
	hurt_detection1 = find_node("Area2D_Damage_Telegraph1")
	hurt_detection2 = find_node("Area2D_Damage_Telegraph2")
	hurt_detection3 = find_node("Area2D_Damage_Telegraph3")
	hurt_detection4 = find_node("Area2D_Damage_Telegraph4")
	
	InitHurtDetection(hurt_detection1)
	InitHurtDetection(hurt_detection2)
	InitHurtDetection(hurt_detection3)
	InitHurtDetection(hurt_detection4)
	var _error = hurt_detection1.connect("OnEndAreaLinger", self, "_on_Area2D_Damage_OnEndAreaLinger")
	
	SpinActiveTimer = GlobalFunctions.CreateTimerAndBind(self, self, "SpinActive_Timeout")
	SpinActiveTimer.set_one_shot(true)
	
	AnchorNode = get_node("Anchor")
	AnchorNode.set_as_toplevel(true)
	
func SpinActive_Timeout():
	Activate()

func DoAbility():
	.DoAbility()
	
	AnchorNode.set_global_position(GenerateTargetPosition())
	
	SpinActiveTimer.start(Spin_ReactivateDuration)
	
	hurt_detection1.SetActive(true)
	hurt_detection2.SetActive(true)
	hurt_detection3.SetActive(true)
	hurt_detection4.SetActive(true)

func ForceEndAbility():
	EndAbility()
	SpinActiveTimer.stop()
	
	
func GenerateTargetPosition() -> Vector2:
	var result:Vector2
	var random_position:Vector2 = Vector2(rand_range(-RandomRadius, RandomRadius), rand_range(-RandomRadius, RandomRadius))
	var inner_vector = random_position.normalized() * InnerRadius
	if is_instance_valid(TargetActor):
		result = TargetActor.GetTargetingPosition() + random_position + inner_vector
		if bUseTopLeftBottomRight : 
			result.x = clamp(result.x, top_left.x, bottom_right.x)
			result.y = clamp(result.y, top_left.y, bottom_right.y)
		
	if bTargetSelf : 
		result = AbilityOwner.GetTargetingPosition()
		
	return result
