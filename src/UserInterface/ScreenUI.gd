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

func _ready():
	player = autoload_transient.player
	player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats

func _process(delta):
	hp_value.set_text( str("HP : ", player_current_stat.CurrentHP) )
	hp_bar.value = player_current_stat.CurrentHP
	
	lvl_value.set_text( str("LVL : ", player_current_stat.CurrentLevel) )
	
	exp_value.set_text( str("EXP : ", player_current_stat.CurrentEXP) )
	exp_bar.value = player_current_stat.CurrentEXP
	
