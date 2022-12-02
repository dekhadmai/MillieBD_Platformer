extends Control


onready var autoload_transient = $"/root/AutoLoadTransientData"
var player: Actor
var player_current_stat: CharacterStats

onready var hp_value = $ColorRect/Hpvalue
onready var hp_bar = $ColorRect/Hpbar
onready var fevor_value = $ColorRect/Fevorvalue
onready var fevor_bar = $ColorRect/Fevorbar
onready var exp_value = $ColorRect/Expvalue
onready var exp_bar = $ColorRect/Expbar
onready var lvl_value = $ColorRect/Lvlvalue
onready var death_value = $ColorRect2/DeathCounter
onready var enemy_value = $ColorRect2/RemainingEnemy


func Init() -> bool:
	player = autoload_transient.player
	if is_instance_valid(player) :
		player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats
		hp_bar.set_max(player_current_stat.BaseHP)
		return true
		
	return false

func _process(delta):
	if is_instance_valid(player_current_stat):
		hp_value.set_text( str("HP : %.0f" % player_current_stat.CurrentHP) )
		hp_bar.value = player_current_stat.CurrentHP
		hp_bar.set_max(player_current_stat.BaseHP)
		
		lvl_value.set_text( str("LVL : ", player_current_stat.CurrentLevel) )
		
		exp_value.set_text( str("XP:", player_current_stat.CurrentEXP, "/", player_current_stat.MaxEXP) )
		exp_bar.value = player_current_stat.CurrentEXP
		exp_bar.set_max(player_current_stat.MaxEXP)
		
		fevor_value.set_text( str("MP : ", player_current_stat.CurrentFervor) )
		fevor_bar.value = player_current_stat.CurrentFervor
		
		death_value.set_text(str("Death : ", autoload_transient.PlayerSaveData.DeathCount))
		enemy_value.set_text(str("Enemies : ", autoload_transient.room_enemy_count))
	
	else:
		Init()
		
		hp_value.set_text( str("HP : ", 0) )
		hp_bar.value = 0
