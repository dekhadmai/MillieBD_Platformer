extends Node


const SAVEFILE = "user://INPUTMAPPING.cfg"
const DEFAULTFILE = "res://src/UserInterface/KeyRemapping/DefaultKeyMapping.tres"


var game_data = {}


func _ready():
	load_data(false)


func load_data(b_load_default):
	var file = ConfigFile.new()
	var valid = false
	if !b_load_default : 
		valid = file.load(SAVEFILE) == OK
	else : 
		valid = file.load(DEFAULTFILE) == OK

	if valid : 
		valid = file.has_section("input")

	if !valid: 
		save_data()

	for section in file.get_sections():
		match(section) : 
			"input":
				for key in file.get_section_keys(section):
					InputMap.action_erase_events(key)
					var events = file.get_value(section, key)
					for event in events :
						InputMap.action_add_event(key, event)
	pass
	
	
func save_data():
	var file = ConfigFile.new()
	for action in InputMap.get_actions():
		file.set_value("input", action, InputMap.get_action_list(action))
	
	file.save(SAVEFILE)
	
		
