extends Node


const SAVEFILE = "user://SAVEFILE.save"


var game_data = {}


func _ready():
	load_data()


func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		game_data = {
			"vsync_on": false,
			"fullscreen_on": false,
			"master_vol": -10,
			"bgm_vol": -10,
			"sfx_vol": -10,
			"hold_to_float": false,
		}
		save_data()
	file.open(SAVEFILE, File.READ)
	game_data = file.get_var()
	
	if !game_data.has("vsync_on") :
		game_data.vysnc_on = false
	if !game_data.has("fullscreen_on") :
		game_data.fullscreen_on = false	
	if !game_data.has("master_vol") :
		game_data.master_vol = -10
	if !game_data.has("bgm_vol") :
		game_data.bgm_vol = -10
	if !game_data.has("sfx_vol") :
		game_data.sfx_vol = -10
	if !game_data.has("hold_to_float") :
		game_data.hold_to_float = false
	
	file.close()
	
	
func save_data():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()
		
