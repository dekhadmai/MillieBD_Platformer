extends Control


onready var close_btn = $Statsbox/LeftPage/Close
onready var expand_btn = $Statsbox/RighPage/Control/Expand
onready var statsUI_Anim = $StatUiAnim
onready var bars = $Statsbox/RighPage/Bars
onready var stats = $Statsbox/RighPage/Stats
onready var resistance_and_weakness = $Statsbox/RighPage/ResistanceAndWeakness
onready var abilityui = $AbilitiesUI

onready var autoload_transient = $"/root/AutoLoadTransientData"
var player_current_stat: CharacterStats
var player: Actor

onready var hp_value = $Statsbox/RighPage/Bars/HpControl/HpValue
onready var hp_bar = $Statsbox/RighPage/Bars/HpControl/HpBar
onready var fevor_value = $Statsbox/RighPage/Bars/FevorControl/FevorValue
onready var fevor_bar = $Statsbox/RighPage/Bars/FevorControl/FevorBar
onready var exp_value = $Statsbox/RighPage/Bars/EpxControl/ExpValue
onready var exp_bar = $Statsbox/RighPage/Bars/EpxControl/ExpBar
onready var lvl_value = $Statsbox/RighPage/Stats/LvlValue
onready var attack_value = $Statsbox/RighPage/Stats/AttackValue
onready var move_speed_value = $Statsbox/RighPage/Stats/MoveSpeedValue


var inventor_is_expanded = false

func Init()->bool:
	player = autoload_transient.player
	if is_instance_valid(player) :
		player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats
		return true
	
	return false


func _process(delta):
	if is_instance_valid(player_current_stat) :
		hp_value.set_text( str("", player_current_stat.CurrentHP) )
		hp_bar.value = player_current_stat.CurrentHP
		
		fevor_value.set_text( str("", player_current_stat.CurrentFervor) )
		fevor_bar.value = player_current_stat.CurrentFervor
		exp_value.set_text( str("", player_current_stat.CurrentEXP) )
		exp_bar.value = player_current_stat.CurrentEXP
		exp_bar.set_max(player_current_stat.MaxEXP)
		lvl_value.set_text( str("", player_current_stat.CurrentLevel) )
		attack_value.set_text( str("", player_current_stat.CurrentAttack) )
		move_speed_value.set_text( str("", player_current_stat.CurrentMovespeed) )
	else:
		Init()
	

func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause") and (GlobalSettings.character_menu_up == true and GlobalSettings.ability_menu_up == false):
		statsUI_Anim.play("StatUiAnimOut")
		yield(statsUI_Anim,'animation_finished')
		GlobalSettings.character_menu_up = false
	
	elif event.is_action_pressed("toggle_pause") and (GlobalSettings.character_menu_up == true and GlobalSettings.ability_menu_up == true):
		statsUI_Anim.play_backwards("NextPage")
		yield(statsUI_Anim,'animation_finished')
		GlobalSettings.ability_menu_up = false


func _on_Close_pressed():
	GlobalSettings.character_menu_up = false
	statsUI_Anim.play("StatUiAnimOut")


func _on_Expand_pressed():
	if not inventor_is_expanded:
		bars.hide()
		stats.hide()
		resistance_and_weakness.hide()
		statsUI_Anim.play("TextAdjustment")
		inventor_is_expanded = true
	
	else:
		statsUI_Anim.play_backwards("TextAdjustment")
		yield(statsUI_Anim,'animation_finished')
		bars.show()
		stats.show()
		resistance_and_weakness.show()
		inventor_is_expanded = false


func _on_Ability_pressed():
	GlobalSettings.ability_menu_up = true
	statsUI_Anim.play("NextPage")
	

func _on_BacktoStats_pressed():
	statsUI_Anim.play_backwards("NextPage")
	yield(statsUI_Anim,'animation_finished')
	GlobalSettings.ability_menu_up = false

