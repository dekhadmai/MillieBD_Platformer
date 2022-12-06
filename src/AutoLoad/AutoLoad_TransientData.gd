extends Node


# Put variable/data that is persistent across levels here
var pause_menu
var player: Player
var room_enemy_count: int = 0
onready var PlayerSaveData: SaveData = SaveData.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

