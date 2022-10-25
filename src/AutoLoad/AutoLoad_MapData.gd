extends Node

var CreateInstanceQueue = []
var InstanceQueueTimer: Timer
var InstanceQueueInterval = 0.05

export var bSpawnOneRoom: bool = false
export var bUseTestRoom: bool = false
export(String, FILE) var TestRoom

export(Array, String, FILE) var RandomLevelPool
var LevelRoomMapPool = []

var startroom_row = 2
var startroom_col = 0

var LevelRoomMap = []
var GridWidth = 10
var GridHeight = 5
var DoorChance = 15
var TotalRoomAvailable: int = 0

var CurrentPlayerRoom: Vector2 setget SetCurrentRoom

export(String, FILE, "*.tscn") var PlayerTemplate
onready var player_template = load(PlayerTemplate)
var player
func SpawnPlayer():
	player = player_template.instance()
	player.set_global_position(Vector2(100,150))
	add_child(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	InstanceQueueTimer = GlobalFunctions.CreateTimerAndBind(self, self, "_ProcessInstanceQueue")
	InstanceQueueTimer.set_one_shot(true)
	
	if (bSpawnOneRoom and bUseTestRoom) : 
		GridWidth = 1
		GridHeight = 1
		startroom_row = 0
		startroom_col = 0
	
	for i in RandomLevelPool.size() :
		if RandomLevelPool[i] != null :
			LevelRoomMapPool.append(RandomLevelPool[i])
	
	GenerateRooms()
	print("\n")
	
	print_map()
	
	pass # Replace with function body.

func _ProcessInstanceQueue():
	var queue_data = CreateInstanceQueue.pop_back()
	CreateInstanceFromQueue(queue_data.r, queue_data.c, queue_data.d)
	if CreateInstanceQueue.size() > 0:
		InstanceQueueTimer.start(InstanceQueueInterval)
	pass
	
func CreateInstanceFromQueue(row, column, room_direction):
	
	var room_data:LevelRoomData
	var room = null# = CreateRoomInstance(row, column)
	if room == null:
		if column < 0 or column >= GridWidth :
			return
	
		if row < 0 or row >= GridHeight :
			return
			
		room_data = LevelRoomMap[row][column]
		room = room_data.RoomInstance
		
	if room == null:
		return
	
	if (room_direction == "Up"):
		var room_up = CreateRoomInstance(row-1, column)
		if room_up != null:
			#add_child(room_up)
			SetPositionNextRoom(room, "Door_Up", room_up, "Door_Down")
			add_child(room_up)
	if (room_direction == "Down"):
		var room_down = CreateRoomInstance(row+1, column)
		if room_down != null:
			#add_child(room_down)
			SetPositionNextRoom(room, "Door_Down", room_down, "Door_Up")
			add_child(room_down)
	if (room_direction == "Left"):
		var room_left = CreateRoomInstance(row, column-1)
		if room_left != null:
			#add_child(room_left)
			SetPositionNextRoom(room, "Door_Left", room_left, "Door_Right")
			add_child(room_left)
	if (room_direction == "Right"):
		var room_right = CreateRoomInstance(row, column+1)
		if room_right != null:
			#add_child(room_right)
			SetPositionNextRoom(room, "Door_Right", room_right, "Door_Left")
			add_child(room_right)

func SetCurrentRoom(vec: Vector2):
	if vec != CurrentPlayerRoom :
		LevelRoomMap[CurrentPlayerRoom.x][CurrentPlayerRoom.y].CurrentLocation = false
		CurrentPlayerRoom = vec
		LevelRoomMap[CurrentPlayerRoom.x][CurrentPlayerRoom.y].bIsExplored = true
		LevelRoomMap[CurrentPlayerRoom.x][CurrentPlayerRoom.y].CurrentLocation = true
		if LevelRoomMap[CurrentPlayerRoom.x][CurrentPlayerRoom.y].RoomInstance :
			LevelRoomMap[CurrentPlayerRoom.x][CurrentPlayerRoom.y].RoomInstance.SetCurrentRoom()

func GenerateRooms():
	LevelRoomMap = []
	TotalRoomAvailable = 0
	
	for i in GridHeight:
		LevelRoomMap.append([])
		for j in GridWidth:
			var level_room_data: LevelRoomData = LevelRoomData.new()
			if bUseTestRoom and TestRoom != "":
				level_room_data.LevelRoomTemplate = TestRoom
			else:
				level_room_data.LevelRoomTemplate = LevelRoomMapPool[randi() % LevelRoomMapPool.size()]
			LevelRoomMap[i].append(level_room_data)
			
	randomize()
	#seed(35)
	
	# start in the middle
	LevelRoomMap[startroom_row][startroom_col].bStartRoom = true
	LevelRoomMap[startroom_row][startroom_col].bIsExplored = true
	SetCurrentRoom(Vector2(startroom_row, startroom_col))
	Traverse(startroom_row, startroom_col, -1, -1, 0)
	
	if bSpawnOneRoom and bUseTestRoom : 
		LevelRoomMap[startroom_row][startroom_col].bIsDoorOpened[1] = 1
		
#		LevelRoomMap[startroom_row][startroom_col].bIsDoorOpened[0] = 1
#		LevelRoomMap[startroom_row][startroom_col].bIsDoorOpened[2] = 1
#		LevelRoomMap[startroom_row][startroom_col].bIsDoorOpened[3] = 1
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
	

func CanSpawnRoom(row: int, column: int) -> bool:
	
	if column < 0 or column >= GridWidth :
		return false
	
	if row < 0 or row >= GridHeight :
		return false
	
	var room_data:LevelRoomData = LevelRoomMap[row][column]
	if room_data.bActive :
		return false
		
	for i in 4:
		if room_data.bIsDoorOpened[i] == 1:
			return true
		
	return false

func CreateRoomInstance(row: int, column: int) -> BaseLevelRoom:
	var room = null
	if CanSpawnRoom(row, column):
		var room_data:LevelRoomData = LevelRoomMap[row][column]
		var tmp_room = load(room_data.LevelRoomTemplate)
		room = tmp_room.instance()
		room_data.bActive = true
		room_data.RoomInstance = room
		room.SetRoomPosition(row, column)
		
		#print("CreateRoomInstance : " + str(row) + "," + str(column))
		
		var text: String = "[" + str(row) + "]" + "[" + str(column) + "]\n"
		
		if room_data.bIsDoorOpened[0] == 1:
			text += "<"
		else:
			text += " "
			
		if room_data.bIsDoorOpened[1] == 1:
			text += "^"
		else:
			text += " "
		
		if room_data.bIsDoorOpened[2] == 1:
			text += ">"
		else:
			text += " "
			
		if room_data.bIsDoorOpened[3] == 1:
			text += "v"
		else:
			text += " "
		
		room.SetText(text)

		if room_data.bIsDoorOpened[0] == 1 :
			var door:Door = room.find_node("Door_Left")
			room.OpenDoor(door)
#
		if room_data.bIsDoorOpened[1] == 1 :
			var door:Door = room.find_node("Door_Up")
			room.OpenDoor(door)
#
		if room_data.bIsDoorOpened[2] == 1 :
			var door:Door = room.find_node("Door_Right")
			room.OpenDoor(door)
#
		if room_data.bIsDoorOpened[3] == 1 :
			var door:Door = room.find_node("Door_Down")
			room.OpenDoor(door)
	
	return room

# spawn room and its adjacent rooms
func SpawnRooms(row: int, column: int) -> void :
	var room_data:LevelRoomData
	var room = null# = CreateRoomInstance(row, column)
	if room == null:
		if column < 0 or column >= GridWidth :
			return
	
		if row < 0 or row >= GridHeight :
			return
			
		room_data = LevelRoomMap[row][column]
		room = room_data.RoomInstance
	else:
		room.set_global_position(Vector2(0,0))
		room.add_child(room)
		
	if room == null:
		return
	
	var data = {r = row, c = column, d = "Up"}
	CreateInstanceQueue.push_back(data)
	
	data = {r = row, c = column, d = "Down"}
	CreateInstanceQueue.push_back(data)
	
	data = {r = row, c = column, d = "Left"}
	CreateInstanceQueue.push_back(data)
	
	data = {r = row, c = column, d = "Right"}
	CreateInstanceQueue.push_back(data)
	
	InstanceQueueTimer.start(InstanceQueueInterval)
	
#	var room_up = CreateRoomInstance(row-1, column)
#	if room_up != null:
#		#add_child(room_up)
#		SetPositionNextRoom(room, "Door_Up", room_up, "Door_Down")
#		add_child(room_up)
#	var room_down = CreateRoomInstance(row+1, column)
#	if room_down != null:
#		#add_child(room_down)
#		SetPositionNextRoom(room, "Door_Down", room_down, "Door_Up")
#		add_child(room_down)
#	var room_left = CreateRoomInstance(row, column-1)
#	if room_left != null:
#		#add_child(room_left)
#		SetPositionNextRoom(room, "Door_Left", room_left, "Door_Right")
#		add_child(room_left)
#	var room_right = CreateRoomInstance(row, column+1)
#	if room_right != null:
#		#add_child(room_right)
#		SetPositionNextRoom(room, "Door_Right", room_right, "Door_Left")
#		add_child(room_right)
	
	pass

func DespawnRooms(row: int, column: int) -> void :
	var tmp: Vector2 = Vector2(row, column)
	if not(row-1 == CurrentPlayerRoom.x and column == CurrentPlayerRoom.y):
		RemoveRoomInstance(row-1, column)
	if not(row+1 == CurrentPlayerRoom.x and column == CurrentPlayerRoom.y):
		RemoveRoomInstance(row+1, column)
	if not(row == CurrentPlayerRoom.x and column-1 == CurrentPlayerRoom.y):
		RemoveRoomInstance(row, column-1)
	if not(row == CurrentPlayerRoom.x and column+1 == CurrentPlayerRoom.y):
		RemoveRoomInstance(row, column+1)
	pass

func RemoveRoomInstance(row: int, column: int) :
	if column < 0 or column >= GridWidth :
		return
	
	if row < 0 or row >= GridHeight :
		return
	
	var room_data:LevelRoomData = LevelRoomMap[row][column]
	if room_data.bActive or room_data.RoomInstance != null:
		room_data.RoomInstance.queue_free()
		room_data.RoomInstance = null
		room_data.bActive = false
		
	pass

func InitSpawnRooms():
	var room
	room = CreateRoomInstance(startroom_row, startroom_col)
	if room != null:
		room.global_position = Vector2(0,0)
		add_child(room)
	
	SpawnRooms(startroom_row, startroom_col)
	
	pass

func SetPositionNextRoom(current_room: BaseLevelRoom, exit, next_room: BaseLevelRoom, entrance):
	var exit_node:Door = current_room.find_node(exit)
	var entrance_node:Door = next_room.find_node(entrance)
	
	var offset = (current_room.global_position)
	offset.y += exit_node.position.y - entrance_node.position.y
	offset.x += exit_node.position.x - entrance_node.position.x
	next_room.set_global_position(offset)
	
	pass
