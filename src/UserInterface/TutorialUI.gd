extends Control


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") : 
		GlobalSettings.tutorial_up = false
		queue_free()
			
	if Input.is_action_just_pressed("ui_cancel") : 
		GlobalSettings.tutorial_up = false
		queue_free()
