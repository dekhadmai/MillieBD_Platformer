extends Node


const SAVEFILE = "user://PlayerProfile.save"

var LevelRoomMap = []
var CheckpointData = {}

var PlayerSaveData

var game_data = {}

var bLoadSaveFile = false

func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		return
		
	file.open(SAVEFILE, File.READ)
	game_data = file.get_var()
	
	if game_data.has("CheckpointData") : 
		AutoLoadMapData.Checkpoint_Position = game_data.CheckpointData.Checkpoint_Position
		AutoLoadMapData.Checkpoint_RoomPosition = game_data.CheckpointData.Checkpoint_RoomPosition
		AutoLoadMapData.Checkpoint_RoomGlobalPosition = game_data.CheckpointData.Checkpoint_RoomGlobalPosition
		AutoLoadMapData.CurrentPlayerRoom = game_data.CheckpointData.CurrentPlayerRoom
	
	if game_data.has("LevelRoomMap") : 
		AutoLoadMapData.LoadData(game_data.LevelRoomMap)
		
	if game_data.has("PlayerSaveData") : 
		AutoLoadTransientData.PlayerSaveData.LoadData(game_data.PlayerSaveData)
	
	file.close()
	
	bLoadSaveFile = true
	
	
func save_data():
	
	CheckpointData.CurrentPlayerRoom = AutoLoadMapData.CurrentPlayerRoom
	CheckpointData.Checkpoint_Position = AutoLoadMapData.Checkpoint_Position
	CheckpointData.Checkpoint_RoomPosition = AutoLoadMapData.Checkpoint_RoomPosition
	CheckpointData.Checkpoint_RoomGlobalPosition = AutoLoadMapData.Checkpoint_RoomGlobalPosition
	
	LevelRoomMap = AutoLoadMapData.GetSaveData()
	
	PlayerSaveData = AutoLoadTransientData.PlayerSaveData.GetSaveData()
	
	game_data.CheckpointData = CheckpointData
	game_data.LevelRoomMap = LevelRoomMap
	game_data.PlayerSaveData = PlayerSaveData
	
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()
		
