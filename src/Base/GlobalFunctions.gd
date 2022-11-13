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

static func CreateTimerAndBind(parent_object, bind_object, bind_function_name) -> Timer:
	var timer: Timer = Timer.new()
	parent_object.add_child(timer)
	timer.connect("timeout", bind_object, bind_function_name)
	timer.set_one_shot(true)
	return timer

static func queue_free_children(node: Node) -> void:
	for n in node.get_children():
		#node.remove_child(n)
		n.queue_free()

static func SpawnDropFromLocation(parent, location, drop_template, b_random_velocity) : 
	var drop_instance = load(drop_template).instance()
	if drop_instance : 
		drop_instance.set_as_toplevel(true)
		parent.add_child(drop_instance)
		drop_instance.set_global_position(location)
		if b_random_velocity : 
			var velocity_direction = Vector2(0, -1)
			var random_angle = (randi()%30)-15
			velocity_direction = velocity_direction.rotated(deg2rad(random_angle))
			drop_instance.set_linear_velocity(velocity_direction * 400.0)
	return drop_instance

##### Physics stuff
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
