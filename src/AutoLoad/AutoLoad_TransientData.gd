extends Node


signal keymapping_change

# Put variable/data that is persistent across levels here
var bSlowTimeActive = false
var bJustLoad = false
var exit_door
var pause_menu
var player: Player
var room_enemy_count: int = 0
onready var PlayerSaveData: SaveData = SaveData.new()

var game_difficulty
var game_mode


export(Array, String) var tmp_ability_drop_pool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GetRandomAbilityDropFromPool() : 
	if tmp_ability_drop_pool.size() == 0 : 
		tmp_ability_drop_pool.append_array(AutoloadGlobalResource.PlayerSpecialAbilityTemplates.keys())
		
	if is_instance_valid(player) : 
		for n in player.SpecialAbilityTemplateNameArray : 
			tmp_ability_drop_pool.erase(n)
			
	tmp_ability_drop_pool.shuffle()
	
	$AbilityDropPoolResetTimer.start()
	
	return tmp_ability_drop_pool.pop_back()


func _on_AbilityDropPoolResetTimer_timeout():
	tmp_ability_drop_pool.clear()
