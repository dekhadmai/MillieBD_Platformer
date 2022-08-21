extends Node

onready var test_room = load("res://src/Level/LevelRoom.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func InitSpawnRooms():
	var room = test_room.instance()
	var room2 = test_room.instance()
	var room3 = test_room.instance()
	room.global_position = Vector2(0,0)
	add_child(room)
	add_child(room2)
	add_child(room3)
	
	SetPositionNextRoom(room, "Door_Down", room2, "Door_Up")
	SetPositionNextRoom(room, "Door_Right", room3, "Door_Left")
	pass

func SetPositionNextRoom(current_room, exit, next_room, entrance):
	var exit_node:Node2D = current_room.find_node(exit)
	var entrance_node:Node2D = next_room.find_node(entrance)
	
	var offset = (current_room.global_position)
	offset.y += exit_node.position.y - entrance_node.position.y
	offset.x += exit_node.position.x - entrance_node.position.x
	next_room.global_position = offset
	
	pass
