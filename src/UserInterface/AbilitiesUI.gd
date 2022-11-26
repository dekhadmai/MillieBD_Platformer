extends Control

onready var weapon1 = $AbilityPage/LeftPage/weapon1
onready var weapon2 = $AbilityPage/LeftPage/weapon2
onready var skill1 = $AbilityPage/RightPage/Skill1
onready var skill2 = $AbilityPage/RightPage/Skill2
onready var skill3 = $AbilityPage/RightPage/Skill3


func init():
	weapon1.init()
	weapon2.init()
	skill1.init()
	skill2.init()
	skill3.init()
	
