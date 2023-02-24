extends Node

var bAnyButtonPress: bool = false
onready var LingerTimer: Timer = $ButtonPressLingerTime

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if AutoLoadMapData.CurrentGameMode == "BulletTime" : 
		if LingerTimer.is_stopped() : 
			bAnyButtonPress = false
		
		if Input.is_action_pressed("move_left"):
			bAnyButtonPress = true
		elif Input.is_action_pressed("move_right"):
			bAnyButtonPress = true
#		elif Input.is_action_pressed("move_up"):
#			bAnyButtonPress = true
#		elif Input.is_action_pressed("move_down"):
#			bAnyButtonPress = true
		elif Input.is_action_pressed("shoot"):
			bAnyButtonPress = true
			LingerTimer.start()
		elif Input.is_action_pressed("jump"):
			bAnyButtonPress = true
		elif Input.is_action_pressed("dash"):
			bAnyButtonPress = true
			LingerTimer.start()
		elif Input.is_action_pressed("use_ability"):
			bAnyButtonPress = true
			LingerTimer.start()
		elif Input.is_action_pressed("Skill1"):
			bAnyButtonPress = true
			LingerTimer.start()
		elif Input.is_action_pressed("Skill2"):
			bAnyButtonPress = true
			LingerTimer.start()
		elif Input.is_action_pressed("Skill3"):
			bAnyButtonPress = true
			LingerTimer.start()
		
	
		if bAnyButtonPress : 
			if !AutoLoadTransientData.bSlowTimeActive : 
				Engine.time_scale = 1.0
		else : 
			Engine.time_scale = 0.1
			
			
		if get_tree().paused or Transition.transition_anim.is_playing() : 
			Engine.time_scale = 1.0


func _on_ButtonPressLingerTime_timeout():
	pass # Replace with function body.
