extends CanvasLayer

onready var transition_anim = $AnimationPlayer


func change_scene(target: String, type: String = 'transition') -> void:
	
	if type == 'transition':
		transition_dissolve(target)
	else:
		transition_clouds(target)

func transition_dissolve(target: String) -> void:
	transition_anim.play("transition")
	yield(transition_anim,'animation_finished')
	transition_anim.play_backwards('transition')
	get_tree().change_scene(target)
	
#-----For Different type transition--------
	
func transition_clouds(target: String) -> void:
	transition_anim.play('clouds_in')
	yield(transition_anim,'animation_finished')
	get_tree().change_scene(target)
	transition_anim.play('clouds_out')





