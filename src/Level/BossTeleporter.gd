extends Node2D

onready var autoload_mapdata = $"/root/AutoLoadMapData"


func _on_CheckpointArea2D_body_entered(body):
	autoload_mapdata.DespawnAllRooms()
	autoload_mapdata.SpawnBossRoomDelay()
