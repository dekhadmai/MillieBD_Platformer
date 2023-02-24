extends Node
# This class contains controls that should always be accessible, like pausing
# the game or toggling the window full-screen.


# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenuV2
onready var pause_anim = $InterfaceLayer/PauseMenuV2/PauseMenuAnim
onready var settings_anim = $InterfaceLayer/PauseMenuV2/CanvasLayer/SettingsMenu/AnimationPlayer
onready var fullscreen_btn = $InterfaceLayer/PauseMenuV2/CanvasLayer/SettingsMenu/Settings/VBoxContainer/SettingsContainer/VideoSetings/Fullscreen

onready var autoload_mapdata = $"/root/AutoLoadMapData"

func _init():
#	OS.min_window_size = OS.window_size
#	OS.max_window_size = OS.get_screen_size()
	pass


func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		# We need to clean up a little bit first to avoid Viewport errors.
		if name == "Splitscreen":
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()

#------------Deleted lines are Mostly recoded on PauseMenu and Settings Menu-----------------------------


func _ready():
	
	if !PlayerProfile.bLoadSaveFile : 
		autoload_mapdata.init()
		autoload_mapdata.InitSpawnRooms()

	
	autoload_mapdata.SpawnPlayer()
	
	pass


func _on_JustLoadTimer_timeout():
	AutoLoadTransientData.bJustLoad = false
	
	autoload_mapdata.CurrentGameMode = AutoLoadTransientData.game_mode
	autoload_mapdata.CurrentGameDifficulty = AutoLoadTransientData.game_difficulty
