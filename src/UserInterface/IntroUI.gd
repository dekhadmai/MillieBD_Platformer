extends Control


export(Array, Texture) var Slides
onready var Slide: TextureRect = $Slide
onready var DialogPlayer = $DialogPlayer
onready var Dialog = $DialogPlayer/Dialog
onready var DialogControl = $DialogPlayer/DialogControl

var slide_index = 0
var bAlreadyTransitioned = false

func _ready(): 
	Slide.set_texture(Slides[slide_index])
	
func _process(delta):
	if !DialogControl.is_active : 
		if Input.is_action_just_pressed("ui_accept") : 
			$StartDialogTimer.start()
	
		
func _on_StartDialogTimer_timeout():
	if slide_index < Slides.size() : 
		if Slide.get_texture() != Slides[slide_index] : 
			Slide.set_texture(Slides[slide_index])
		else : 
			StartDialog(slide_index)
	else : 
		if !bAlreadyTransitioned : 
			Transition.change_scene("res://src/Main/Game.tscn")
			bAlreadyTransitioned = true
	
##### dialog stuff
func StartDialog(index):
	GlobalSettings.dialog_test_up = true
	GlobalSettings.dialog_reset = false
	
	Dialog.dialog_file = "res://src/UserInterface/Dialog/DialogData/Dialog_Intro" + str(index+1) + ".tres"
	
	Dialog.init()
	DialogControl.init()
	
	
	#get_tree().paused = true
	DialogPlayer.show()
	DialogControl.show_dialog()
	
	get_tree().paused = true
	
	slide_index += 1
	
	
#	if GlobalSettings.dialog_reset == false:	
#			GlobalSettings.dialog_test_up = true
#			get_tree().paused = true
#			dialog_system.show()
#			get_node("DialogPlayer/DialogControl").show_dialog()
#
#		else:
#			GlobalSettings.dialog_test_up = true
#			GlobalSettings.dialog_reset = false
#			get_node("DialogPlayer/DialogControl").dialog_index = 0
#			dialog_system.show()
#			get_node("DialogPlayer/DialogControl").show_dialog()
#			get_tree().paused = true
	
#	elif event.is_action_pressed("dialog_test") and get_tree().paused == false:
#		if GlobalSettings.dialog_reset == false:	
#			GlobalSettings.dialog_test_up = true
#			get_tree().paused = true
#			dialog_system.show()
#			get_node("DialogPlayer/DialogControl").show_dialog()



