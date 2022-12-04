extends Control

onready var hp_bar = $HpBar
onready var mp_bar = $MpBar

func _process(_delta):
	var player = AutoLoadTransientData.player
	if is_instance_valid(player) : 
		if hp_bar : 
			hp_bar.value = player.ability_system_component.CurrentCharStats.CurrentHP
			hp_bar.set_max(player.ability_system_component.CurrentCharStats.BaseHP)
			
		if mp_bar : 
			mp_bar.value = player.ability_system_component.CurrentCharStats.CurrentFervor
			mp_bar.set_max(player.ability_system_component.CurrentCharStats.MaxFervor)
