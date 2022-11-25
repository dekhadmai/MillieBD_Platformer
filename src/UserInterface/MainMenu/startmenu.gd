extends Control


onready var animation_player = $CanvasLayer/SettingsMenu/AnimationPlayer
onready var Start_Btn = $ColorRect/StartBtn



func _ready():
	Start_Btn.grab_focus()


func _on_StartBtn_pressed():
	#Transition.change_scene("res://src/Main/Game.tscn")
	Transition.change_scene("res://src/UserInterface/IntroUI.tscn")


func _on_SettingsBtn_pressed():
	animation_player.play("SettingsBook")
	GlobalSettings.settings_menu_up = true
	
	
func _on_QuitBtn_pressed():
	get_tree().quit()







