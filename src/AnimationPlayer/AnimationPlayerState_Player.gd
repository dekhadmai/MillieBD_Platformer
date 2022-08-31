extends AnimationPlayerState

func GetCurrentAnimName() -> String:
	var currentanim:String = .GetCurrentAnimName()
	
	if currentanim == "up_jumping":
		currentanim = "jumping"
	elif currentanim == "down_jumping":
		currentanim = "jumping"
	elif currentanim == "up_falling":
		currentanim = "falling"
	elif currentanim == "down_falling":
		currentanim = "falling"
	elif currentanim == "down_idle_active_weapon":
		currentanim = "down_idle_weapon"
	elif currentanim == "up_idle_active_weapon":
		currentanim = "up_idle_weapon"
	
	elif currentanim == "up_run_active_weapon" or currentanim == "down_run_active_weapon":
		currentanim = "run_active_weapon"
	elif currentanim == "up_run_weapon" or currentanim == "down_run_weapon":
		currentanim = "run_weapon"
#	elif currentanim == "up_run_active_weapon" or currentanim == "up_run_weapon":
#		currentanim = "up_idle_weapon"
#	elif currentanim == "down_run_active_weapon" or currentanim == "down_run_weapon":
#		currentanim = "down_idle_weapon"
	
	return currentanim
