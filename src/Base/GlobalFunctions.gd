class_name GlobalFunctions
extends Node

static func IsKeyModifierPressed(var just_pressed_key:String, var hold_key:String) -> bool:
	if Input.is_action_just_pressed(just_pressed_key):	
		if Input.is_action_pressed(hold_key):
			return true
	
	return false

static func GetOwnerObject(object) : 
	var parent = object.get_parent()	
	while !((parent.get_class() == "Actor") or (parent.get_class() == "BaseBullet")):
		parent = parent.get_parent()
	
	#print(parent.get_class())
	return parent

static func RotationToVector(radian) : 
	return Vector2(cos(radian), sin(radian))
	#return Vector2.RIGHT.rotated(radian)
