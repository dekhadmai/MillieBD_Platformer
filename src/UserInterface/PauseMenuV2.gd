extends Control


onready var settings = $CanvasLayer/SettingsMenu
onready var pause_anim =  $PauseMenuAnim
onready var settings_anim = $CanvasLayer/SettingsMenu/AnimationPlayer



onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)


func _ready():
	#hide()
	pass


func _unhandled_input(event):
		
	if event.is_action_pressed("toggle_pause"):

		if get_tree().paused == true and GlobalSettings.settings_menu_up == false:
			pause_anim.play_backwards("Pause")
			yield(pause_anim,'animation_finished')
			get_tree().paused = false
		
		elif GlobalSettings.settings_menu_up == false:
			pause_anim.play("Pause")
			get_tree().paused = true


func _on_Resume_pressed():
	pause_anim.play_backwards("Pause")
	yield(pause_anim,'animation_finished')
	#resume_button.release_focus()
	get_tree().paused = false


func _on_Settings_pressed():
	settings_anim.play("SettingsBook")
	GlobalSettings.settings_menu_up = true


func _on_Quit_pressed():
	scene_root.notification(NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()

