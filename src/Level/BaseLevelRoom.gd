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

func SetCurrentRoom():
	SetRoomCondition(0)
	
func SetRoomCondition(condition: int): # 0 = lock door, 1 = open door
	var room_data = autoload_mapdata.LevelRoomMap[Room_Position.x][Room_Position.y]
	if tilemap == null:
		tilemap = find_node("TileMap")
		
	if room_data.bIsDoorOpened[0] == 1 :
		var door:Door = find_node("Door_Left")
		SetDoorCondition(condition, door, tilemap)
	
	if room_data.bIsDoorOpened[1] == 1 :
		var door:Door = find_node("Door_Up")
		SetDoorCondition(condition, door, tilemap)
		
	if room_data.bIsDoorOpened[2] == 1 :
		var door:Door = find_node("Door_Right")
		SetDoorCondition(condition, door, tilemap)
		
	if room_data.bIsDoorOpened[3] == 1 :
		var door:Door = find_node("Door_Down")
		SetDoorCondition(condition, door, tilemap)
			
func SetDoorCondition(condition, door, tilemap): # 0 = lock door, 1 = open door
	if condition == 0 : 
		door.LockDoor(tilemap)
	elif condition == 1 :
		door.OpenDoor(tilemap)
	
func _on_CheckRoomClearCondition_timeout():
	var child_array = get_children()
	
	for i in child_array.size():
		if child_array[i].get_class() == "Actor" :
			return
			
	SetRoomCondition(1)
	

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
		var current_room_vect : Vector2 = Room_Position
		current_room_vect.y -= 1
		autoload_mapdata.SetCurrentRoom(current_room_vect)
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Right_PlayerExited(body):
	if body.global_position.x > door_right.global_position.x:
		var current_room_vect : Vector2 = Room_Position
		current_room_vect.y += 1
		autoload_mapdata.SetCurrentRoom(current_room_vect)
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Up_PlayerExited(body):
	if body.global_position.y < door_up.global_position.y:
		var current_room_vect : Vector2 = Room_Position
		current_room_vect.x -= 1
		autoload_mapdata.SetCurrentRoom(current_room_vect)
		autoload_mapdata.DespawnRooms(Room_Position.x, Room_Position.y)
	pass # Replace with function body.


func _on_Door_Down_PlayerExited(body):
	if body.global_position.y > door_down.global_position.y:
		var current_room_vect : Vector2 = Room_Position
		current_room_vect.x += 1
		autoload_mapdata.SetCurrentRoom(current_room_vect)
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

