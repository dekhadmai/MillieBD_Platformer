class_name AnimationPlayerState
extends AnimationPlayer

var BaseAnimState: String
var CustomAnimState: String
var CustomAnimTimer: Timer

func GetCurrentAnimName() -> String:
	return BaseAnimState + CustomAnimState
	
func PlayCustomAnim(custom_anim_name: String, seconds: float = 0.0):
	CustomAnimState = custom_anim_name
	CustomAnimTimer.start(seconds)

# Called when the node enters the scene tree for the first time.
func _ready():
	CustomAnimTimer = get_node("CustomAnimTimer")
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
