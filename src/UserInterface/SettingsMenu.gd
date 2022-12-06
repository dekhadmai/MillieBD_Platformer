extends Control


onready var animation_player = $AnimationPlayer
onready var vsync_btn = $Settings/VBoxContainer/SettingsContainer/VideoSetings/Vsync
onready var fullscreen_btn = $Settings/VBoxContainer/SettingsContainer/VideoSetings/Fullscreen
onready var Master_volume_slider = $Settings/VBoxContainer/SettingsContainer/MasterVolumebox/Volume
onready var Bgm_volume_slider = $Settings/VBoxContainer/SettingsContainer/Bgmbox/BgmSlider
onready var Sfx_volume_slider = $Settings/VBoxContainer/SettingsContainer/Sfx/SfxSlider

onready var flippage = $Flippage
onready var bookmark_1 = $NinePatchRect
onready var bookmark_2 = $NinePatchRect2
onready var clickblocker = $Clickblocker

var master_volume = AudioServer.get_bus_index("Master")



# Called when the node enters the scene tree for the first time.
func _ready():
	
	vsync_btn.pressed = SettingsSave.game_data.vsync_on
	fullscreen_btn.pressed = SettingsSave.game_data.fullscreen_on
	
	Master_volume_slider.value = SettingsSave.game_data.master_vol
	Bgm_volume_slider.value = SettingsSave.game_data.bgm_vol
	Sfx_volume_slider.value = SettingsSave.game_data.sfx_vol
	
func _physics_process(delta):
	if GlobalSettings.controls_menu_closed == true:
		animation_player.play_backwards("Controls")
		yield(animation_player,'animation_finished')
		GlobalSettings.controls_menu_up = false
		GlobalSettings.controls_menu_closed = false
		
		pass
		
	if GlobalSettings.settings_menu_up == true and GlobalSettings.controls_menu_up == true:
		
		pass
		
	if GlobalSettings.controls_menu_up == false:
		flippage.hide()
		bookmark_1.hide()
		bookmark_2.hide()
		pass
	
func _unhandled_input(event):
	if ((event.is_action_pressed("toggle_pause") and GlobalSettings.settings_menu_up == true
	) and (GlobalSettings.controls_menu_up == false and GlobalSettings.controls_menu_closed == false)):
		
		animation_player.play_backwards("SettingsBook")
		yield(animation_player,'animation_finished')
		GlobalSettings.settings_menu_up = false
	
	elif (event.is_action_pressed("toggle_pause") and GlobalSettings.settings_menu_up == true
	) and GlobalSettings.controls_menu_up == true:
		
		animation_player.play_backwards("Controls")
		yield(animation_player,'animation_finished')
		GlobalSettings.controls_menu_up = false

func _on_BackButton_pressed():
	animation_player.play_backwards("SettingsBook")
	GlobalSettings.settings_menu_up = false

func _on_Vsync_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)


func _on_Fullscreen_toggled(button_pressed):
	GlobalSettings.toggle_fullscreen(button_pressed)


func _on_Volume_value_changed(value):
	GlobalSettings.update_master_vol(value)
	
	
func _on_BgmSlider_value_changed(value):
	GlobalSettings.update_bgm_vol(value)


func _on_SfxSlider_value_changed(value):
	GlobalSettings.update_sfx_vol(value)

func _on_HoldToFloat_toggled(button_pressed):
	GlobalSettings.toggle_hold_to_float(button_pressed)


func _on_Controls_pressed():
	set_process_unhandled_input(false)
	clickblocker.show()
	GlobalSettings.controls_menu_up = true
	animation_player.play("Controls")
	yield(animation_player,'animation_finished')	
	var ui = load("res://src/UserInterface/KeyRemapping/InputRemapMenu.tscn")
	add_child(ui.instance())
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	set_process_unhandled_input(true)
	clickblocker.hide()
