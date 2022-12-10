extends ColorRect



onready var skill_indicator1 = $"Conection skill"
onready var skill_indicator2 = $"Conection skill2"
onready var skill_indicator3 = $"Conection skill3"

func _ready():
	pass # Replace with function body.

func _process(delta):
#	print("nani")
	var player = AutoLoadTransientData.player
	if is_instance_valid(player) :
#		print(player.SpecialAbilityIndex)
		if player.SpecialAbilityIndex == 0:
#			print("nani")
			skill_indicator1.color = Color(0.054, 0.639, 0.807, 1)
			skill_indicator2.color = Color(0.168, 0.168, 0.168, 1)
			skill_indicator3.color = Color(0.168, 0.168, 0.168, 1)
	
		if player.SpecialAbilityIndex == 1:
			skill_indicator2.color = Color(0.054, 0.639, 0.807, 1)
			skill_indicator1.color = Color(0.168, 0.168, 0.168, 1)
			skill_indicator3.color = Color(0.168, 0.168, 0.168, 1)
			
		if player.SpecialAbilityIndex == 2:
			skill_indicator3.color = Color(0.054, 0.639, 0.807, 1)
			skill_indicator1.color = Color(0.168, 0.168, 0.168, 1)
			skill_indicator2.color = Color(0.168, 0.168, 0.168, 1)
