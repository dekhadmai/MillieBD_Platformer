class_name Checkpoint
extends Node2D

onready var autoload_mapdata = $"/root/AutoLoadMapData"


func _on_CheckpointArea2D_body_entered(body):
	autoload_mapdata.Checkpoint_Position = get_global_position()
	print("Set Checkpoint")
	pass # Replace with function body.
