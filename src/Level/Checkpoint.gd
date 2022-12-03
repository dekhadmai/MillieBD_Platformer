class_name Checkpoint
extends Node2D

onready var autoload_mapdata = $"/root/AutoLoadMapData"
onready var anim = $AnimationPlayer

var Checkpoint_RoomPosition

func _ready():
	Checkpoint_RoomPosition = get_parent().Room_Position
	if autoload_mapdata.Checkpoint_RoomPosition == Checkpoint_RoomPosition : 
		anim.play("activate")

func _on_CheckpointArea2D_body_entered(body):
	if autoload_mapdata.Checkpoint_RoomPosition != Checkpoint_RoomPosition : 
		autoload_mapdata.PlaySfx("Checkpoint")
		
	autoload_mapdata.Checkpoint_Position = get_global_position()
	autoload_mapdata.Checkpoint_RoomPosition = Checkpoint_RoomPosition
	autoload_mapdata.Checkpoint_RoomGlobalPosition = get_parent().get_global_position()
	
	anim.play("activate")
	print("Set Checkpoint")
	
	body.save_player_transient_data()
	PlayerProfile.save_data()
	
	pass # Replace with function body.

func _play_loop_anim():
	anim.play("loop")
