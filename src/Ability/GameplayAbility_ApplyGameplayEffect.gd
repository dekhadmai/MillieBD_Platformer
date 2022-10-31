extends BaseGameplayAbility

func DoAbility():
	.DoAbility()
	
	var effect:BaseGameplayEffect = GameplayeEffect_Template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = AbilityOwner.GetAbilitySystemComponent()
	
	body_asc.ApplyGameplayEffectToSelf(effect)
	
	EndAbility()
