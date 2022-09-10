extends BaseGameplayAbility

func _on_GrazeArea_body_entered(body):
	body.StartGraze(AbilityOwner)
	pass # Replace with function body.

func _on_GrazeArea_body_exited(body):
	body.StopGraze()
	pass # Replace with function body.


func _on_GrazeArea_area_entered(area):
	var body = area.GetOwnerObject()
	if body.get_class() == "BaseBullet":
		if body.Instigator.GetTeam() != AbilityOwner.GetTeam():
			body.StartGraze(AbilityOwner)
	elif body.get_class() == "Actor": 
		if body.GetTeam() != AbilityOwner.GetTeam():
			body.StartGraze(AbilityOwner)

	pass # Replace with function body.


func _on_GrazeArea_area_exited(area):
	var body = area.GetOwnerObject()
	body.StopGraze()
	pass # Replace with function body.
