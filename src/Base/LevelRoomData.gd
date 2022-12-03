class_name LevelRoomData
extends Node

var RoomInstance: BaseLevelRoom = null
var bTraversed: bool = false
var Distance:int = -1
var bActive = false

##### UI information
var bStartRoom: bool = false
var bIsAlreadyCleared: bool = false
var bSpawnDropOnClear: bool = true
var LevelRoomTemplate: String
var RoomType: String
var CurrentLocation: bool = false
var bIsExplored: bool = false


# left, up, right, down || 0 = undefined, 1 = open, 2 = close, 3 = locked
var bIsDoorOpened = [0, 0, 0, 0]

func GetSaveData() : 
	var json = {
		"bTraversed" : bTraversed,
		"Distance" : Distance,
		"bStartRoom" : bStartRoom,
		"bIsAlreadyCleared" : bIsAlreadyCleared,
		"bSpawnDropOnClear" : bSpawnDropOnClear,
		"LevelRoomTemplate" : LevelRoomTemplate,
		"RoomType" : RoomType,
		"CurrentLocation" : CurrentLocation,
		"bIsExplored" : bIsExplored,
		"bIsDoorOpened" : bIsDoorOpened
	}
	return json
	
func LoadData(data) : 
	bTraversed = data.bTraversed
	Distance = data.Distance
	bStartRoom = data.bStartRoom
	bIsAlreadyCleared = data.bIsAlreadyCleared
	bSpawnDropOnClear = data.bSpawnDropOnClear
	LevelRoomTemplate = data.LevelRoomTemplate
	RoomType = data.RoomType
	CurrentLocation = data.CurrentLocation
	bIsExplored = data.bIsExplored
	bIsDoorOpened = data.bIsDoorOpened
