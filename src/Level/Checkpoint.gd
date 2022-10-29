class_name Checkpoint
extends Node2D

onready var autoload_mapdata = $"/root/AutoLoadMapData"


func _on_CheckpointArea2D_body_entered(body):
	autoload_mapdata.Checkpoint_Position = get_global_position()
	autoload_mapdata.Checkpoint_RoomPosition = get_parent().Room_Position
	autoload_mapdata.Checkpoint_RoomGlobalPosition = get_parent().get_global_position()
	print("Set Checkpoint")
	pass # Replace with function body.
