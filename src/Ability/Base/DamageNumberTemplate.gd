extends Node2D

onready var damage_number_label = $DamageNumberLabel
onready var duration_timer = $TextDuration

export var random_velocity_angle = 50
export var text_speed = 200
export var text_gravity = 10
export var offset = Vector2(-8,-10)

var velocity_direction = Vector2.ZERO
var gravity_accu = 0

func _process(delta):
	damage_number_label.set_global_position(damage_number_label.get_global_position() + (velocity_direction*text_speed*delta) + Vector2(0,gravity_accu))
	gravity_accu += text_gravity*delta

func Init(parent, value) : 
	if random_velocity_angle > 0 : 
		velocity_direction = Vector2(0, -1)
		var random_angle = (randi()%random_velocity_angle)-(random_velocity_angle/2)
		velocity_direction = velocity_direction.rotated(deg2rad(random_angle))
		
	damage_number_label = $DamageNumberLabel
	duration_timer = $TextDuration
	parent.add_child(self)
	
	damage_number_label.set_as_toplevel(true)
	damage_number_label.set_text(str(value))
	damage_number_label.set_global_position(parent.get_global_position() + offset)
	duration_timer.start()

func _on_TextDuration_timeout():
	queue_free()
