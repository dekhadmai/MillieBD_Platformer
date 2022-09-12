class_name BaseArea2D_Telegraph
extends BaseArea2D

export var TelegraphAnimName: String = "telegraph_loop"
export var TelegraphAnimDuration: float = 1.0

onready var telegraph_timer: Timer = $TelegraphTimer


func _on_TelegraphTimer_timeout():
	.SetActive(true)
	pass # Replace with function body.


func SetActive(val: bool):
	if val and TelegraphAnimDuration > 0 :
		set_visible(true)
		GetAnimPlayer().play(TelegraphAnimName)
		telegraph_timer.start(TelegraphAnimDuration)
	else:
		.SetActive(val)
