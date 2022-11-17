extends Control

onready var autoload_mapdata = $"/root/AutoLoadMapData"
onready var starting_pos = $XY
onready var minimap_visible = $ColorRect

var LD_room	= preload("res://assets/art/ui/Map/LDopen.png")
var RLUP_room = preload("res://assets/art/ui/Map/4open.png")
var empty_room = preload("res://assets/art/ui/Map/Empty.png")
var DU_room = preload("res://assets/art/ui/Map/UDopen.png")
var RLD_room = preload("res://assets/art/ui/Map/RLDopen.png")
var L_room = preload("res://assets/art/ui/Map/Lopen.png")
var start_icon = preload("res://assets/art/ui/Map/Start.png")
var checkpoint_icon = preload("res://assets/art/ui/Map/Checkpoint.png")
var boss_icon = preload("res://assets/art/ui/Map/Boss.png")
var current_pos = preload("res://assets/art/ui/Map/millie_icon.png")


var width = 10
var height = 5

export var wall_line = Vector2(0.96,0.96)
export var scale_map = Vector2(1.4,1.4)

var Map = []
var box_id = []

func _ready():
	Map = autoload_mapdata.LevelRoomMap
	width = autoload_mapdata.GridWidth
	height = autoload_mapdata.GridHeight
	_add_room_ui()
	#print(Map[0][0])


func _add_room_ui():
	var room_pos = Vector2(starting_pos.position.x,starting_pos.position.y)
	var size = Vector2(0,0)
	
	var col = 0
	var row = 1
	
	
	for i in height:
	#	box_id.push_back([])
		for j in width:
			var room_data:LevelRoomData = Map[i][j]
			var room_ui = Sprite.new()
	#		box_id[i].push_back(room_data)
			get_node("ColorRect/MarginContainer").add_child(room_ui)
			room_ui.texture = empty_room
			room_ui.scale = scale_map
			var room_size_x = (room_ui.texture.get_size().x * room_ui.scale.x)
			var room_size_y = (room_ui.texture.get_size().y * room_ui.scale.y)
			size.y = room_size_y

			if col <  width:
				#print(room_pos)
				room_ui.set_position(room_pos)
				room_pos += Vector2((room_size_x * wall_line.x), 0)
				col += 1
			
#				if room_data.bStartRoom:
#					var start = Sprite.new()
#					get_node("ColorRect/MarginContainer").add_child(start)
#					start.texture = start_icon
#					start.set_position(room_ui.get_position())
#					#start.rotation_degrees = -room_ui.rotation_degrees
#					#print(room_ui.get_position())
					
				
				var icon = Sprite.new()
				get_node("ColorRect/MarginContainer").add_child(icon)
				if room_data.RoomType == "C" and room_data.bIsExplored : 
					icon.texture = checkpoint_icon
				if room_data.RoomType == "B" : 
					icon.texture = boss_icon
				icon.set_position(room_ui.get_position())
				
				if room_data.CurrentLocation:
					var location = Sprite.new()
					get_node("ColorRect/MarginContainer").add_child(location)
					location.texture = current_pos
					location.set_position(room_ui.get_position())
#					print(room_ui.get_position())
#					print("aaaaaaaaaa")
				
				if !room_data.bIsExplored:
					room_ui.use_parent_material = true
				
				
				if (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = RLUP_room

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = empty_room

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = L_room

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = L_room
					room_ui.rotation_degrees = 90

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = L_room
					room_ui.rotation_degrees = 180

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = L_room
					room_ui.rotation_degrees = 270

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = DU_room

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = DU_room
					room_ui.rotation_degrees = 90

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = LD_room

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = LD_room
					room_ui.rotation_degrees = 90

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = LD_room
					room_ui.rotation_degrees = 180

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = LD_room
					room_ui.rotation_degrees = 270

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 2) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = RLD_room

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 2 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = RLD_room
					room_ui.rotation_degrees = 90

				elif (room_data.bIsDoorOpened[0] == 1 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 2)):
					room_ui.texture = RLD_room
					room_ui.rotation_degrees = 180

				elif (room_data.bIsDoorOpened[0] == 2 and room_data.bIsDoorOpened[1] == 1) and (
					(room_data.bIsDoorOpened[2] == 1 and room_data.bIsDoorOpened[3] == 1)):
					room_ui.texture = RLD_room
					room_ui.rotation_degrees = 270
				
					

#				print(room_data)

		room_pos = Vector2(starting_pos.position.x,(((size.y * row) * wall_line.y) + starting_pos.position.y))
		col = 0
		row += 1
		
	pass


#func _current_location(row:int, col:int):
#	var room_data:LevelRoomData = Map[row][col]
#	var CurrentPlayerRoom = autoload_mapdata.CurrentPlayerRoom
#
#	if (((row-1 == CurrentPlayerRoom.x and col == CurrentPlayerRoom.y) or (
#		row+1 == CurrentPlayerRoom.x and col == CurrentPlayerRoom.y)) or (
#		(row == CurrentPlayerRoom.x and col-1 == CurrentPlayerRoom.y) or (
#		row == CurrentPlayerRoom.x and col+1 == CurrentPlayerRoom.y))):
#
#		room_data.CurrentLocation = false
#	pass

func _remove_room_ui():
	
	for n in get_node("ColorRect/MarginContainer").get_children():
		get_node("ColorRect/MarginContainer").remove_child(n)
		n.queue_free()
	Map = []	
	
	pass
