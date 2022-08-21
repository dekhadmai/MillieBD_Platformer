class_name AnimationPlayerState
extends AnimationPlayer

var BaseAnimState: String
var CustomAnimState: String
var FullBodyAnimState: String
var CustomAnimTimer: Timer
var FullBodyAnimTimer: Timer
var bIsPlayingFullBodyAnim: bool = false

func GetCurrentAnimName() -> String:
	if bIsPlayingFullBodyAnim:
		return FullBodyAnimState
	else:
		return BaseAnimState + CustomAnimState
	
func PlayCustomAnim(custom_anim_name: String, seconds: float = 0.0):
	CustomAnimState = custom_anim_name
	CustomAnimTimer.start(seconds)
	
func PlayFullBodyAnim(fullbody_anim_name: String, seconds: float = 0.0):
	FullBodyAnimState = fullbody_anim_name
	FullBodyAnimTimer.start(seconds)
	bIsPlayingFullBodyAnim = true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	CustomAnimTimer = get_node("CustomAnimTimer")
	FullBodyAnimTimer = get_node("FullBodyAnimTimer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var animation = GetCurrentAnimName()
	if animation != current_animation:
		play(animation)
	
	pass


func _on_CustomAnimTimer_timeout():
	CustomAnimState = ""
	pass # Replace with function body.


func _on_FullBodyAnimTimer_timeout():
	FullBodyAnimState = ""
	bIsPlayingFullBodyAnim = false
	pass # Replace with function body.
