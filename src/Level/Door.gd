class_name Door
extends Node2D

onready var door_area: Area2D = $DoorArea2D
export var bVerticalDoor = true

signal PlayerEntered(body)
signal PlayerExited(body)

func _ready():
	pass

func ReplaceTile(tilemap: TileMap, tile_id_to_replace: int):
	var local_position = tilemap.to_local(global_position)
	var map_position = tilemap.world_to_map(local_position)
	
	var flip_x = false
	var flip_y = false
	var transpose = false
	var node_name = get_name()
	if node_name == "Door_Left":
		flip_x = true
		flip_y = false
		transpose = true
	
	if node_name == "Door_Right":
		flip_x = false
		flip_y = false
		transpose = true
		
	if node_name == "Door_Up":
		flip_x = false
		flip_y = true
		transpose = false
		
	if node_name == "Door_Down":
		flip_x = false
		flip_y = false
		transpose = false
		
	
	var pos = map_position;
	if bVerticalDoor :
		for i in 3:
			pos = map_position;
			pos.y += (i-1)
			tilemap.set_cellv(pos, tile_id_to_replace, flip_x, flip_y, transpose)
	else :
		for i in 3:
			pos = map_position;
			pos.x += (i-1)
			tilemap.set_cellv(pos, tile_id_to_replace, flip_x, flip_y, transpose)
	
	

func OpenDoor(tilemap: TileMap):
	ReplaceTile(tilemap, -1)
	if door_area == null:
		door_area = find_node("DoorArea2D")
	door_area.set_monitoring(true)


func LockDoor(tilemap: TileMap):
	ReplaceTile(tilemap, 3)
	if door_area == null:
		door_area = find_node("DoorArea2D")
	door_area.set_monitoring(false)


func _on_DoorArea2D_body_entered(body):
	emit_signal("PlayerEntered", body)
	pass # Replace with function body.


func _on_DoorArea2D_body_exited(body):
	emit_signal("PlayerExited", body)
	pass # Replace with function body.
