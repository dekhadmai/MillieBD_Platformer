extends Node


var master_volume = AudioServer.get_bus_index("Master")

var settings_menu_up = false
var character_menu_up = false
var ability_menu_up = false
var dialog_test_up = false
var dialog_reset = false
var pause_on_dialog = false


func toggle_fullscreen(toggle):
	OS.window_fullscreen = toggle
#	OS.window_fullscreen = !OS.window_fullscreen
	SettingsSave.game_data.fullscreen_on = toggle
	SettingsSave.save_data()


func toggle_vsync(toggle):
	OS.vsync_enabled = toggle
	SettingsSave.game_data.vsync_on = toggle
	SettingsSave.save_data()
	
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(master_volume, vol)
	SettingsSave.game_data.master_vol = vol
	SettingsSave.save_data()
	
	if vol == -30:
		AudioServer.set_bus_mute(master_volume, true)
	else:
		AudioServer.set_bus_mute(master_volume, false)
