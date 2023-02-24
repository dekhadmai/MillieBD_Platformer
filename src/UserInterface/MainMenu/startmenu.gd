extends Control


onready var animation_player = $CanvasLayer/SettingsMenu/AnimationPlayer
onready var Start_Btn = $ColorRect/StartBtn

var bSkipIntroSlide = false

func _ready():
	Start_Btn.grab_focus()
	AutoLoadMapData.CurrentGameMode = "Normal"


func _on_StartBtn_pressed():
	AutoLoadTransientData.game_difficulty = "Normal"
	AutoLoadTransientData.game_mode = "Normal"
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
	AutoLoadMapData.init()
	PlayerProfile.load_data()
	AutoLoadMapData.print_map()
	
	AutoLoadTransientData.bJustLoad = true
	Transition.change_scene("res://src/Main/Game.tscn")


func _on_EasyBtn_pressed():
	AutoLoadTransientData.game_difficulty = "Easy"
	AutoLoadTransientData.game_mode = "Normal"
	if bSkipIntroSlide : 
		Transition.change_scene("res://src/Main/Game.tscn")
	else : 
		Transition.change_scene("res://src/UserInterface/IntroUI.tscn")


func _on_BulletTimeBtn_pressed():
	AutoLoadTransientData.game_difficulty = "Normal"
	AutoLoadTransientData.game_mode = "BulletTime"
	if bSkipIntroSlide : 
		Transition.change_scene("res://src/Main/Game.tscn")
	else : 
		Transition.change_scene("res://src/UserInterface/IntroUI.tscn")
