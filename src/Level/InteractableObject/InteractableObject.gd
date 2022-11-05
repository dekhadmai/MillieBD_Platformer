class_name InteractableObject
extends Node2D

export var Name: String = "Name"
export var Description: String = "Description"

onready var autoload_mapdata = $"/root/AutoLoadMapData"
onready var item_name_label = $ItemName

var bPlayerInRange = false
var InteractedPlayer

var hold_timer: Timer
export var hold_duration = 1.0
var bFinishHold = false

func _ready():
	Init()
	hold_timer = GlobalFunctions.CreateTimerAndBind(self, self, "hold_timer_timeout")

func _process(delta):
	if bPlayerInRange : 
		if Input.is_action_just_pressed("interact") :
			hold_timer.start(hold_duration)
			
		if Input.is_action_just_released("interact") :
			if bFinishHold : 
				HoldAction()
				bFinishHold = false
			else : 
				TapAction()
				bFinishHold = false
		
	pass

func Init():
	pass

func TapAction():
	#print("Tap")
	pass
	
func HoldAction():
	#print("Hold")
	pass

func hold_timer_timeout():
	bFinishHold = true

func _on_CheckpointArea2D_body_entered(body):
	if body is Player : 
		bPlayerInRange = true
		InteractedPlayer = body

func _on_CheckpointArea2D_body_exited(body):
	if body is Player : 
		bPlayerInRange = false
		bFinishHold = false
		hold_timer.stop()
		InteractedPlayer = null
