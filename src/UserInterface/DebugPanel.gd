extends Panel

onready var fps_label = $FPSContainer/FPSLabel

func _process(delta):
	fps_label.set_text( str(Engine.get_frames_per_second()) )
	pass
