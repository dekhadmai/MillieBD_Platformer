extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") : 
		InputSave.save_data()
		queue_free()

func _on_SaveButton_pressed():
	InputSave.save_data()
	queue_free()
	pass # Replace with function body.


func _on_DefaultButton_pressed():
	InputSave.load_data(true)
	InputSave.save_data()
	queue_free()
	pass # Replace with function body.
