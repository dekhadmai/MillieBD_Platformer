extends Node2D

onready var choice1 = $Choice1
onready var choice2 = $Choice2

var choice_counter = 1
var choice_dialog_is_up = false


func _on_Choice1_pressed():
	choice1.hide()
	choice2.hide()
	choice_dialog_is_up = false
#	get_parent().show_dialog()
#	get_parent().dialog_index += 1

	AutoLoadTransientData.player.DialogDeath_GetBuff()
	get_parent().CloseDialog()
	


func _on_Choice2_pressed():
	choice1.hide()
	choice2.hide()
	choice_dialog_is_up = false
#	get_parent().dialog_index += 1
#	get_parent().show_dialog()

	get_parent().CloseDialog()

