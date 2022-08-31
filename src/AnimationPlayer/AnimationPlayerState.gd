class_name AnimationPlayerState
extends AnimationPlayer

var BaseAnimState: String
var LingeringState: String
var CustomAnimState: String
var FullBodyAnimState: String
var CustomAnimTimer: Timer
var FullBodyAnimTimer: Timer
var LingeringAnimTimer: Timer
var bIsPlayingFullBodyAnim: bool = false
var LastAnimation: String

func GetCurrentAnimName() -> String:
	if bIsPlayingFullBodyAnim:
		return FullBodyAnimState
	else:
		if CustomAnimState != "" : 
			return BaseAnimState + CustomAnimState
		else:
			return BaseAnimState + LingeringState
	
func PlayCustomAnim(custom_anim_name: String, seconds: float = 0.0):
	CustomAnimState = custom_anim_name
	CustomAnimTimer.start(seconds)
	
func PlayFullBodyAnim(fullbody_anim_name: String, seconds: float = 0.0):
	FullBodyAnimState = fullbody_anim_name
	FullBodyAnimTimer.start(seconds)
	bIsPlayingFullBodyAnim = true
	
func SetLingeringAnim(lingering_anim_name: String, seconds: float = 0.0):
	LingeringState = lingering_anim_name
	LingeringAnimTimer.start(seconds)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	CustomAnimTimer = get_node("CustomAnimTimer")
	FullBodyAnimTimer = get_node("FullBodyAnimTimer")
	LingeringAnimTimer = get_node("LingeringAnimTimer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var animation = GetCurrentAnimName()
	var ac = current_animation
	if animation != LastAnimation:
		play(animation)
		LastAnimation = animation
		print(animation)
	
	pass


func _on_CustomAnimTimer_timeout():
	CustomAnimState = ""
	pass # Replace with function body.


func _on_FullBodyAnimTimer_timeout():
	FullBodyAnimState = ""
	bIsPlayingFullBodyAnim = false
	pass # Replace with function body.


func _on_LingeringAnimTimer_timeout():
	LingeringState = ""
	pass # Replace with function body.
