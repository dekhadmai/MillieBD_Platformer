extends BaseGameplayAbility

func _on_GrazeArea_body_entered(body):
	body.StartGraze(AbilityOwner)
	pass # Replace with function body.

func _on_GrazeArea_body_exited(body):
	body.StopGraze()
	pass # Replace with function body.

func _on_HurtArea_body_entered(body):
	body.OnBodyEnter(AbilityOwner)
	pass # Replace with function body.



