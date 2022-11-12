extends BaseGameplayAbility

onready var graze_vfx_timer:Timer = $GrazeVfxTimer

func ShowGrazeVfx() : 
	ability_sprite.set_visible(true)
	graze_vfx_timer.start()

func _on_GrazeVfxTimer_timeout():
	ability_sprite.set_visible(false)
