extends Control


onready var settings = $CanvasLayer/SettingsMenu
onready var pause_anim =  $PauseMenuAnim
onready var settings_anim = $CanvasLayer/SettingsMenu/AnimationPlayer
onready var statsui_anim = $CanvasLayer/StatsUI/StatUiAnim
onready var dialog_system = $DialogPlayer



onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)


func _ready():
	#hide()
	pass


func _unhandled_input(event):
		
	if event.is_action_pressed("toggle_pause"):

		if (get_tree().paused == true and GlobalSettings.settings_menu_up == false) and (
			GlobalSettings.character_menu_up == false and GlobalSettings.dialog_test_up == false):
				
			pause_anim.play_backwards("Pause")
			yield(pause_anim,'animation_finished')
			get_tree().paused = false
			
		
		elif GlobalSettings.settings_menu_up == false and (GlobalSettings.character_menu_up == false 
			and GlobalSettings.dialog_test_up == false):
				
			pause_anim.play("Pause")
			get_tree().paused = true
	
#------------------------------------------ Dialog Test --------------------------------------------------------#
	
		elif GlobalSettings.dialog_test_up == true and GlobalSettings.pause_on_dialog == false:
			pause_anim.play("Pause")
			GlobalSettings.pause_on_dialog = true
			
		elif (GlobalSettings.dialog_test_up == true and GlobalSettings.pause_on_dialog == true) and (
			GlobalSettings.settings_menu_up == false and GlobalSettings.character_menu_up == false):
			
			GlobalSettings.pause_on_dialog = false
			pause_anim.play_backwards("Pause")
			
		
	elif event.is_action_pressed("dialog_test") and get_tree().paused == false:
		if GlobalSettings.dialog_reset == false:	
			GlobalSettings.dialog_test_up = true
			get_tree().paused = true
			dialog_system.show()
			get_node("DialogPlayer/DialogControl").show_dialog()
			
		else:
			GlobalSettings.dialog_test_up = true
			GlobalSettings.dialog_reset = false
			get_node("DialogPlayer/DialogControl").dialog_index = 0
			dialog_system.show()
			get_node("DialogPlayer/DialogControl").show_dialog()
			get_tree().paused = true
			
#------------------------------------------ Dialog Test --------------------------------------------------------#

func _on_Resume_pressed():
	pause_anim.play_backwards("Pause")
	yield(pause_anim,'animation_finished')
	#resume_button.release_focus()
	get_tree().paused = false


func _on_Characters_pressed():
	statsui_anim.play("StatUiAnim")
	GlobalSettings.character_menu_up = true

func _on_Settings_pressed():
	settings_anim.play("SettingsBook")
	GlobalSettings.settings_menu_up = true


func _on_Quit_pressed():
	scene_root.notification(NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()



