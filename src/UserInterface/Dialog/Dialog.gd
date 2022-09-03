extends Node


export var dialog_file = ""
var dialog_script


func _ready():
	dialog_script = open_dialog_file()
	assert(dialog_script, "dialog not found")
	
func open_dialog_file() -> Array:
	var dialogs = File.new()
	assert(dialogs.file_exists(dialog_file), "File not found")
	
	dialogs.open(dialog_file, File.READ)
	var json = dialogs.get_as_text()
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
