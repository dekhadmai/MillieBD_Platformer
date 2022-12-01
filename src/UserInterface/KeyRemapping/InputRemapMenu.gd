extends Control



func _on_SaveButton_pressed():
	InputSave.save_data()
	queue_free()
	pass # Replace with function body.


func _on_DefaultButton_pressed():
	InputSave.load_data(true)
	InputSave.save_data()
	queue_free()
	pass # Replace with function body.
