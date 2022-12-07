extends Control


onready var animation_player = $CanvasLayer/SettingsMenu/AnimationPlayer
onready var Start_Btn = $ColorRect/StartBtn

var bSkipIntroSlide = false

func _ready():
	Start_Btn.grab_focus()


func _on_StartBtn_pressed():
	if bSkipIntroSlide : 
		Transition.change_scene("res://src/Main/Game.tscn")
	else : 
		Transition.change_scene("res://src/UserInterface/IntroUI.tscn")


func _on_SettingsBtn_pressed():
	animation_player.play("SettingsBook")
	GlobalSettings.settings_menu_up = true
	
	
func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_Credits_pressed():
	Transition.change_scene("res://src/UserInterface/CreditUI.tscn")


func _on_LoadCheckpoint_pressed():
	PlayerProfile.load_data()
	AutoLoadMapData.print_map()
	
	AutoLoadTransientData.bJustLoad = true
	Transition.change_scene("res://src/Main/Game.tscn")
