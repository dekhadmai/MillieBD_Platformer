extends AnimationPlayer

var BaseAnimState: String
var CustomAnimState: String

func GetCurrentAnimName() -> String:
	return BaseAnimState + "_" + CustomAnimState
	
func PlayCustomAnim(second: float):
	return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
