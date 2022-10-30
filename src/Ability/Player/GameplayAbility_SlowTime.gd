extends BaseGameplayAbility

var SlowTimer: Timer

export var SlowTimeDuration = 1.0
export var TimeScaleAmount = 0.2
export var FadeInTime = 0.2
export var FadeOutTime = 0.5

var current_active_time = 0.0

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

func Deactivate():
	.Deactivate()
	Engine.time_scale = 1.0
