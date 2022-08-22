extends Node

onready var test_room = load("res://src/Level/LevelRoom.tscn")

var LevelRoomMap = []
var GridWidth = 10
var GridHeight = 5
var DoorChance = 15
var TotalRoomAvailable: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	GenerateRooms()
	print("\n")
	print_map()
	
	pass # Replace with function body.

func GenerateRooms():
	LevelRoomMap = []
	TotalRoomAvailable = 0
	
	for i in GridHeight:
		LevelRoomMap.append([])
		for j in GridWidth:
			LevelRoomMap[i].append(LevelRoomData.new())
			
	randomize()
	#seed(35)
	
	# start in the middle
	LevelRoomMap[2][0].bStartRoom = true
	Traverse(2, 0, -1, -1, 0)
	pass

func Traverse(row:int, column:int, from_row: int, from_column: int, distance: int):
	
	#print("Traverse : (" + str(row) + "," + str(column) + ")")
	
	var room_data:LevelRoomData = LevelRoomMap[row][column]
	
	if from_row != -1 :
		# pop the door open from where we came from
		if from_row == row and from_column == column-1:
			room_data.bIsDoorOpened[0] = 1
		if from_row == row-1 and from_column == column:
			room_data.bIsDoorOpened[1] = 1
		if from_row == row and from_column == column+1:
			room_data.bIsDoorOpened[2] = 1
		if from_row == row+1 and from_column == column:
			room_data.bIsDoorOpened[3] = 1
	
	if (room_data.bTraversed):
		return
	
	##### mark this room
	room_data.bTraversed = true
	room_data.Distance = distance
	TotalRoomAvailable += 1
	
	# setup for new room to traverse
	var can_traverse = [0,0,0,0] #left, up, right, down | 0 = can't traverse, 1 = can traverse, 2 = force traverse
	var eligible_options = []
	
	##### check and force open door to traverse
	# check travel left
	if CanTraverse(row, column-1) :
		can_traverse[0] = 1
		eligible_options.append(0)
	
	# check travel up
	if CanTraverse(row-1, column) :
		can_traverse[1] = 1
		eligible_options.append(1)
		
	# check travel right
	if CanTraverse(row, column+1) :
		can_traverse[2] = 1
		eligible_options.append(2)
		
	# check travel down
	if CanTraverse(row+1, column) :
		can_traverse[3] = 1
		eligible_options.append(3)
		
	if eligible_options.size() > 0:
		var force_open_index = eligible_options[randi() % eligible_options.size()]
		can_traverse[force_open_index] = 2
		
	##### actual traverse
	# travel left
	if can_traverse[0] > 0 and (can_traverse[0] == 2 or randi() % 100 < DoorChance):
		room_data.bIsDoorOpened[0] = 1
		Traverse(row, column-1, row, column, distance+1)
	else:
		if room_data.bIsDoorOpened[0] == 0:
			room_data.bIsDoorOpened[0] = 2
		
	# travel up
	if can_traverse[1] > 0 and (can_traverse[1] == 2 or randi() % 100 < DoorChance):
		room_data.bIsDoorOpened[1] = 1
		Traverse(row-1, column, row, column, distance+1)
	else:
		if room_data.bIsDoorOpened[1] == 0:
			room_data.bIsDoorOpened[1] = 2
		
	# travel right
	if can_traverse[2] > 0 and (can_traverse[2] == 2 or randi() % 100 < DoorChance):
		room_data.bIsDoorOpened[2] = 1
		Traverse(row, column+1, row, column, distance+1)
	else:
		if room_data.bIsDoorOpened[2] == 0:
			room_data.bIsDoorOpened[2] = 2
		
	# travel down
	if can_traverse[3] > 0 and (can_traverse[3] == 2 or randi() % 100 < DoorChance):
		room_data.bIsDoorOpened[3] = 1
		Traverse(row+1, column, row, column, distance+1)
	else:
		if room_data.bIsDoorOpened[3] == 0:
			room_data.bIsDoorOpened[3] = 2
	
	pass
	
func CanTraverse(row:int, column:int) -> bool :
	if column < 0 or column >= GridWidth :
		return false
	
	if row < 0 or row >= GridHeight :
		return false
		
	var room_data:LevelRoomData = LevelRoomMap[row][column]
	
	if room_data.bTraversed:
		return false
	
	return true
	
func print_map():
	var result:String = ""
	result += "TotalRoom = " + str(TotalRoomAvailable) + "\n"
	for i in GridHeight:
		for j in GridWidth:
			var room_data:LevelRoomData = LevelRoomMap[i][j]
			
			if !room_data.bStartRoom:
				result += str(room_data.Distance)
				for n in (3 - str(room_data.Distance).length()):
					result += " "
			else:
				result += "S  "
				
			if room_data.bIsDoorOpened[0] == 1:
				result += "<"
			else:
				result += " "
				
			if room_data.bIsDoorOpened[1] == 1:
				result += "^"
			else:
				result += " "
			
			if room_data.bIsDoorOpened[2] == 1:
				result += ">"
			else:
				result += " "
				
			if room_data.bIsDoorOpened[3] == 1:
				result += "v"
			else:
				result += " "
				
			result += " | "
		result += "\n"
	
	print(result)
	pass

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
