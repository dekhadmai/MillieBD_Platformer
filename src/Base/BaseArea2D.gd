class_name BaseArea2D
extends Area2D


func GetOwnerObject() : 
	var parent = get_parent()	
	while !((parent.get_class() == "Actor") or (parent.get_class() == "BaseBullet")):
		parent = parent.get_parent()
	
	print(parent.get_class())
	return parent
