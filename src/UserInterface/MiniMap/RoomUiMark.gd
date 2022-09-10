extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


signal PlayerEntered(body)
signal PlayerExited(body)

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	emit_signal("PlayerEntered", body)
	

func _on_Area2D_body_exited(body):
	emit_signal("PlayerExited", body)
