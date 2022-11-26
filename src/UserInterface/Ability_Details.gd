extends "res://src/UserInterface/InputControl.gd"

onready var ability_cost = $AbilityCost
onready var cooldown = $CooldownRemaining
var ability_instance : BaseGameplayAbility = null

var original_scale = Vector2(0.25, 0.25)
var active_scale = Vector2(0.5, 0.5)

func init() : 
	ability_instance = GetAbilityInstance()
	if is_instance_valid(ability_instance) : 
		sprite_icon.show()
		$AbilityName.show()
		$AbilityDesc.show()
		
		if sprite_icon.get_texture() != ability_instance.AbilityIcon : 
			sprite_icon.set_texture(ability_instance.AbilityIcon)
		
		$AbilityName.set_text(ability_instance.GetAbilityName())
		$AbilityDesc.set_text(ability_instance.GetAbilityDescription())
		if ability_instance.bUseFervor :
			$AbilityCost.show()
			$AbilityCost.set_text("MP : " + str(ability_instance.FervorCost))
		else : 
			$AbilityCost.hide()
	else : 
		sprite_icon.hide()
		$AbilityName.hide()
		$AbilityDesc.hide()
		$AbilityCost.hide()
		
	$KeyboardSprite.hide()
	$ControllerSprite.hide()
	
	
func GetAbilityInstance() -> BaseGameplayAbility: 
	var player = AutoLoadTransientData.player
	if is_instance_valid(player) : 
		if action_name == "dash" : 
			return player.dash_abi
		
		if action_name == "shoot" : 
			return player.weapon_abi
		
		var skill_index = -1
		if action_name == "Skill1" : 
			skill_index = 0
		elif action_name == "Skill2" : 
			skill_index = 1
		elif action_name == "Skill3" : 
			skill_index = 2
		
		if !(skill_index == -1 or player.SpecialAbilityArray.size() < skill_index+1) : 
			return player.SpecialAbilityArray[skill_index]
		
		skill_index = -1
		if action_name == "weapon1" :
			skill_index = 0
		elif action_name == "weapon2" :
			skill_index = 1
			
		if !(skill_index == -1 or player.WeaponAbilityArray.size() < skill_index+1) : 
			return player.WeaponAbilityArray[skill_index]
	
	return null
