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
	file.close()
	
	
func save_data():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()
		
