extends Control


onready var animation_player = $AnimationPlayer
onready var vsync_btn = $Settings/VBoxContainer/SettingsContainer/VideoSetings/Vsync
onready var fullscreen_btn = $Settings/VBoxContainer/SettingsContainer/VideoSetings/Fullscreen
onready var Master_volume_slider = $Settings/VBoxContainer/SettingsContainer/MasterVolumebox/Volume
onready var Bgm_volume_slider = $Settings/VBoxContainer/SettingsContainer/Bgmbox/BgmSlider
onready var Sfx_volume_slider = $Settings/VBoxContainer/SettingsContainer/Sfx/SfxSlider
var master_volume = AudioServer.get_bus_index("Master")



# Called when the node enters the scene tree for the first time.
func _ready():
	
	vsync_btn.pressed = SettingsSave.game_data.vsync_on
	fullscreen_btn.pressed = SettingsSave.game_data.fullscreen_on
	
	Master_volume_slider.value = SettingsSave.game_data.master_vol
	Bgm_volume_slider.value = SettingsSave.game_data.bgm_vol
	Sfx_volume_slider.value = SettingsSave.game_data.sfx_vol
	


func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause") and GlobalSettings.settings_menu_up == true:
		animation_player.play_backwards("SettingsBook")
		yield(animation_player,'animation_finished')
		GlobalSettings.settings_menu_up = false
	

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
