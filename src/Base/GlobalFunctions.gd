class_name GlobalFunctions
extends Node

static func IsKeyModifierPressed(var just_pressed_key:String, var hold_key:String) -> bool:
	if Input.is_action_just_pressed(just_pressed_key):	
		if Input.is_action_pressed(hold_key):
			return true
	
	return false
