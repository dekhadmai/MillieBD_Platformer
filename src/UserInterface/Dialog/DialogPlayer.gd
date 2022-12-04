extends CanvasLayer


export (String, FILE, "*json") var scene_text_file

var scene_text = {}
var selected_text = []
var in_progress = false

onready var dialog_box = $Control/DialogBox
onready var portrait_box = $Control/PortraitBox
onready var dialog = $Control/Dialog

func _ready():
	dialog_box.visible = false
	portrait_box.visible = false
	scene_text = load_scene_text()
	var _error = DialogSignal.connect("display_dialog", self, "on_display_dialog")

func load_scene_text():
	var file = File.new()
	if file.file_exists(scene_text_file):
		file.open(scene_text_file, File.READ)
		return parse_json(file.get_as_text())

func show_text():
	dialog.text = selected_text.pop_front()

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	dialog.text = ""
	dialog_box.visible = false
	portrait_box.visible = false
	in_progress = false
	get_tree().paused = false
	
func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		get_tree().paused = true
		dialog_box.visible = true
		portrait_box.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()

"Unused Dialog System Might used later"
