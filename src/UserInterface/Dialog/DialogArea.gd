extends Area2D

export var text_key = ""
var area_active = false


func _input(event):
	if event.is_action_pressed("dialog_test"):
		DialogSignal.emit_signal("display_dialog", text_key)
		
		

func _on_DialogArea_area_entered(area):
	area_active = true


func _on_DialogArea_area_exited(area):
	area_active = false

"Unused Dialog System Might used later"
