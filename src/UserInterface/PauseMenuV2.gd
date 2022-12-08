extends Control


onready var settings = $CanvasLayer/SettingsMenu
onready var pause_anim =  $PauseMenuAnim
onready var settings_anim = $CanvasLayer/SettingsMenu/AnimationPlayer
onready var statsui_anim = $CanvasLayer/StatsUI/StatUiAnim
onready var dialog_system = $DialogPlayer



onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)


func _ready():
	AutoLoadTransientData.pause_menu = self
	pass

func SpawnPlayer() : 
	$DeathRoastTimer.start()

func _unhandled_input(event):
		
	if event.is_action_pressed("toggle_pause"):

		if (get_tree().paused == true and GlobalSettings.settings_menu_up == false) and ((
			GlobalSettings.character_menu_up == false and GlobalSettings.dialog_test_up == false) and 
			GlobalSettings.controls_menu_up == false):
				
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

	elif event.is_action_pressed("Minimap_test"):
		get_node("Control")._ready()
		$Control.show()
		pass
		
	elif event.is_action_released("Minimap_test"):
		get_node("Control")._remove_room_ui()
		$Control.hide()
		
		pass


func _on_Resume_pressed():
	pause_anim.play_backwards("Pause")
	yield(pause_anim,'animation_finished')
	#resume_button.release_focus()
	get_tree().paused = false


func _on_Characters_pressed():
	statsui_anim.play("StatUiAnim")
	GlobalSettings.character_menu_up = true
	
func _on_Tutorial_pressed():
	var ui = load("res://src/UserInterface/TutorialUI.tscn")
	add_child(ui.instance())

func _on_Settings_pressed():
	settings_anim.play("SettingsBook")
	GlobalSettings.settings_menu_up = true


func _on_Quit_pressed():
	scene_root.notification(NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()


func _on_KeyMapping_pressed():
	var ui = load("res://src/UserInterface/KeyRemapping/InputRemapMenu.tscn")
	add_child(ui.instance())




##### dialog stuff
func _on_DeathRoastTimer_timeout():
	if $"/root/AutoLoadTransientData".PlayerSaveData.DeathCount > 0 and !AutoLoadTransientData.bJustLoad :
		var death_count = $"/root/AutoLoadTransientData".PlayerSaveData.DeathCount-1
		
		if death_count <= 1 : 
			DialogDeath(death_count)
		elif (death_count > 10 and death_count % 3 == 0) or (death_count == 4 or death_count == 8) : 
			DialogDeath_Choices(death_count)
		else : 
			DialogDeath_Famillies(death_count)
			
#		get_node("DialogLayer/DialogPlayerDeath_Choices/DialogControl").bRandomDialog = false
#		DialogDeath_Choices(death_count)
	
func DialogDeath(death_count):
	GlobalSettings.dialog_test_up = true
	GlobalSettings.dialog_reset = false
	
	get_node("DialogLayer/DialogPlayerDeath/Dialog").init()
	get_node("DialogLayer/DialogPlayerDeath/DialogControl").init()
	get_node("DialogLayer/DialogPlayerDeath").show()
	get_node("DialogLayer/DialogPlayerDeath/DialogControl").show_dialog(death_count)
	get_tree().paused = true
	
func DialogDeath_Choices(death_count):
	GlobalSettings.dialog_test_up = true
	GlobalSettings.dialog_reset = false
	
	get_node("DialogLayer/DialogPlayerDeath_Choices/Dialog").init()
	get_node("DialogLayer/DialogPlayerDeath_Choices/DialogControl").init()
	get_node("DialogLayer/DialogPlayerDeath_Choices").show()
	get_node("DialogLayer/DialogPlayerDeath_Choices/DialogControl").show_dialog(death_count)
	get_tree().paused = true

func DialogDeath_Famillies(death_count):
	GlobalSettings.dialog_test_up = true
	GlobalSettings.dialog_reset = false
	
	get_node("DialogLayer/DialogPlayerDeath_Famillies/Dialog").init()
	get_node("DialogLayer/DialogPlayerDeath_Famillies/DialogControl").init()
	get_node("DialogLayer/DialogPlayerDeath_Famillies").show()
	get_node("DialogLayer/DialogPlayerDeath_Famillies/DialogControl").show_dialog(death_count)
	get_tree().paused = true
