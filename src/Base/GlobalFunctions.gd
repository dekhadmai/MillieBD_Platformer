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



static func optimal_angle(x: float, y: float, v0: float, g: float) -> float :
	var root = v0 * v0 * v0 * v0 - g * (g * x * x + 2.0 * y * v0 * v0)
	if root < 0.0 :
		return 0.0;
	
	root = sqrt(root)
	var angle = atan((v0 * v0 - root) / (g * x))
	return angle


static func lob_angle(x: float, y: float, v0: float, g: float) -> float :
	var root = v0 * v0 * v0 * v0 - g * (g * x * x + 2.0 * y * v0 * v0)
	if root < 0.0 :
		return 0.0
	
	root = sqrt(root)
	var angle = atan((v0 * v0 + root) / (g * x))
	return angle


#static func travel_time(x: f32, angle: f32, v0: f32) -> f32 {
#	x / (f32::cos(angle) * v0)
#}


static func calc_arc_velocity(point_a, point_b, arc_height, gravity):
	var velocity = Vector2()
	var displacement = point_b - point_a
	
	if displacement.y > arc_height:
		var time_up = sqrt(-2 * arc_height / float(gravity))
		var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
		
		velocity.y = -sqrt(-2 * gravity * arc_height)
		velocity.x = displacement.x / float(time_up + time_down)
		
	return velocity
