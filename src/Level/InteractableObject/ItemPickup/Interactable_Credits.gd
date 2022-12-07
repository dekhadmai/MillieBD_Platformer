extends InteractableObject

var bActive = false

func _ready():
	AutoLoadTransientData.exit_door = self

func SetActive(val) : 
	set_visible(val)
	bActive = val

func TapAction():
	#print("Tap")
	if bActive : 
		AutoLoadMapData.CleanUp()
		Transition.change_scene("res://src/UserInterface/CreditUI.tscn")
	
