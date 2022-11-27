extends "res://src/UserInterface/Ability_InputControl.gd"


func tick(delta) : 
	var remaining_cd = 0
	ability_instance = GetAbilityInstance()
	
	if is_instance_valid(ability_instance) : 
		if sprite_icon.get_texture() != ability_instance.AbilityIcon : 
			sprite_icon.set_texture(ability_instance.AbilityIcon)
		
		remaining_cd = ability_instance.GetAbilityRemainingCooldownSeconds()
		if remaining_cd > 0 :
			cooldown.set_visible(true)
			set_visible(true)
		else :
			cooldown.set_visible(false)
			set_visible(false)
		
		mask_progress.set_max(ability_instance.AbilityCooldownSecond * 100)
		mask_progress.set_value((remaining_cd) * 100)
		if remaining_cd > 1.0 : 
			cooldown.set_text(str("%.f" % remaining_cd))
		else : 
			cooldown.set_text(str("%.1f" % remaining_cd))
		
		if ability_instance.bUseFervor : 
			ability_cost.set_text(str(ability_instance.FervorCost))
			if !ability_cost.is_visible() : 
				ability_cost.set_visible(true)
		else : 
			if ability_cost.is_visible() : 
				ability_cost.set_visible(false)
				
		var bIsActiveSkill = false
		var player = AutoLoadTransientData.player
		if is_instance_valid(player) : 
			if action_name == "Skill1" and player.SpecialAbilityIndex == 0 :
				bIsActiveSkill = true
			if action_name == "Skill2" and player.SpecialAbilityIndex == 1 :
				bIsActiveSkill = true
			if action_name == "Skill3" and player.SpecialAbilityIndex == 2 :
				bIsActiveSkill = true
			
#			var current_scale = sprite_icon.get_scale()
#			var new_scale
#			if bIsActiveSkill : 
#				new_scale = active_scale
#			else : 
#				new_scale = original_scale
#
#			if current_scale != new_scale :
#				sprite_icon.set_scale(new_scale)
	
	if action_name == "float" : 
		var player = AutoLoadTransientData.player
		if is_instance_valid(player) : 
			mask_progress.set_max(player.float_time_max * 100)
			mask_progress.set_value((player.float_time_remaining) * 100)
			remaining_cd = player.float_time_remaining
			if remaining_cd < player.float_time_max and remaining_cd >= 0 :
				cooldown.set_visible(true)
				set_visible(true)
			else :
				cooldown.set_visible(false)
				set_visible(false)
			if remaining_cd > 1.0 : 
				cooldown.set_text(str("%.f" % remaining_cd))
			else : 
				cooldown.set_text(str("%.1f" % remaining_cd))


