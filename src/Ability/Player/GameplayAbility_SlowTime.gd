extends BaseGameplayAbility

var SlowTimer: Timer

export var SlowTimeDuration = 1.0
export var TimeScaleAmount = 0.1
export var FadeInTime = 0.2
export var FadeOutTime = 0.5

var current_active_time = 0.0

func GetAbilityDescription():
	var result : String = AbilityDescription
	result = result.replace("{EffectValue}", str(GameplayeEffect_Template.ValueToModify))
	result = result.replace("{EffectValuePercent}", str(GameplayeEffect_Template.ValueToModify*100))
	result = result.replace("{EffectValueAtk}", str("%.2f" % (GameplayeEffect_Template.ValueToModify * AbilityOwner.GetAbilitySystemComponent().CurrentCharStats.CurrentAttack/100)))
	result = result.replace("{EffectDuration}", str("%.2f" % SlowTimeDuration))
	result = result.replace("{Cooldown}", str("%.2f" % AbilityCooldownSecond))
	result = result.replace("{Cost}", str("%.0f" % FervorCost))
	return result

func _process(delta):
	if bIsActive :
		if current_active_time <= FadeInTime :
			Engine.time_scale = lerp(1.0, TimeScaleAmount, current_active_time / FadeInTime)
		elif current_active_time >= SlowTimeDuration : 
			EndAbility()
		elif current_active_time >= SlowTimeDuration - FadeOutTime : 
			Engine.time_scale = lerp(TimeScaleAmount, 1.0, (current_active_time - SlowTimeDuration + FadeOutTime) / FadeOutTime)
		
		current_active_time += delta
	

func DoAbility():
	.DoAbility()
	current_active_time = 0.0
	AutoLoadTransientData.bSlowTimeActive = true

func Deactivate():
	.Deactivate()
	Engine.time_scale = 1.0
	AutoLoadTransientData.bSlowTimeActive = false

func CleanUp():
	Engine.time_scale = 1.0
	AutoLoadTransientData.bSlowTimeActive = false
	.CleanUp()
