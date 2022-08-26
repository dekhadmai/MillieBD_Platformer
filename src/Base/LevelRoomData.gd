class_name LevelRoomData
extends Node

var RoomInstance: BaseLevelRoom = null
var bTraversed: bool = false
var Distance:int = 0
var bActive = false

##### UI information
var bStartRoom: bool = false
var bIsAlreadyCleared: bool = false
var LevelRoomTemplate: String
var RoomType: String

# left, up, right, down || 0 = undefined, 1 = open, 2 = close
var bIsDoorOpened = [0, 0, 0, 0]

