class_name BaseLevelRoom
extends Node

onready var autoload_mapdata = $"/root/AutoLoadMapData"
onready var Room_Position: Vector2 # room coordinate in the mapdata grid (not global position)

onready var tilemap:TileMap = $TileMap
onready var bound:Rect2
onready var door_left: Door = $Door_Left
onready var door_right: Door = $Door_Right
onready var door_up: Door = $Door_Up
onready var door_down: Door = $Door_Down
onready var room_label: Label = $RoomLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	#area.shape.set_extents(tilemap.get_used_rect().size)
	var r = tilemap.get_used_rect().size
	var r2 = tilemap.get_global_position()
	
	bound = Rect2(tilemap.get_global_position(), tilemap.get_used_rect().size * tilemap.get_cell_size())
	
	pass # Replace with function body.

func OpenDoor(door: Door) -> void:
	if tilemap == null:
		tilemap = find_node("TileMap")
	door.OpenDoor(tilemap)
	#print(room_label.get_text() + " OpenDoor : " + door.name + "\n")
	
func SetText(text: String) -> void:
	if room_label == null:
		room_label = find_node("RoomLabel")
	room_label.set_text(text)

func SetRoomPosition(row: int, column: int) -> void :
	Room_Position.x = row
	Room_Position.y = column
	pass


func _on_Door_Left_PlayerEntered(body):
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	if room_data.bActive:
		autoload_mapdata.SpawnRooms(Room_Position.x, Room_Position.y-1)
	pass # Replace with function body.


func _on_Door_Right_PlayerEntered(body):
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	if room_data.bActive:
		autoload_mapdata.SpawnRooms(Room_Position.x, Room_Position.y+1)
	pass # Replace with function body.


func _on_Door_Up_PlayerEntered(body):
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	if room_data.bActive:
		autoload_mapdata.SpawnRooms(Room_Position.x-1, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Down_PlayerEntered(body):
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	if room_data.bActive:
		autoload_mapdata.SpawnRooms(Room_Position.x+1, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Left_PlayerExited(body):
	if body.global_position.x < door_left.global_position.x:
		autoload_mapdata.CurrentPlayerRoom = Room_Position
		autoload_mapdata.CurrentPlayerRoom.y -= 1
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Right_PlayerExited(body):
	if body.global_position.x > door_right.global_position.x:
		autoload_mapdata.CurrentPlayerRoom = Room_Position
		autoload_mapdata.CurrentPlayerRoom.y += 1
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Up_PlayerExited(body):
	if body.global_position.y < door_up.global_position.y:
		autoload_mapdata.CurrentPlayerRoom = Room_Position
		autoload_mapdata.CurrentPlayerRoom.x -= 1
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Down_PlayerExited(body):
	if body.global_position.y > door_down.global_position.y:
		autoload_mapdata.CurrentPlayerRoom = Room_Position
		autoload_mapdata.CurrentPlayerRoom.x += 1
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.





func _on_RoomUiMark_PlayerEntered(body):
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	room_data.bIsExplored = true
	room_data.CurrentLocation = true
	print("room entered")
	pass # Replace with function body.


func _on_RoomUiMark_PlayerExited(body):
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	room_data.CurrentLocation = false
	print("room exited")
	pass # Replace with function body.
