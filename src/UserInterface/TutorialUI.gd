extends Control


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") : 
		queue_free()
			
#	if Input.is_action_just_pressed("ui_cancel") : 
#		queue_free()
