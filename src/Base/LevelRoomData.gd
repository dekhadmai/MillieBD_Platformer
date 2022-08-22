class_name LevelRoomData
extends Node

var bTraversed: bool = false
var Distance:int = 0
var bStartRoom: bool = false
var bIsAlreadyCleared: bool = false
var bIsDoorOpened = [0, 0, 0, 0] # left, up, right, down || 0 = undefined, 1 = open, 2 = close
var LevelRoomTemplate: String
var RoomType: String
