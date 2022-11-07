extends Panel

onready var autoload_transient = $"/root/AutoLoadTransientData"
var player: Actor
var player_current_stat: CharacterStats

onready var fps_label = $VBoxContainer/FPSLabel
onready var hp_label = $VBoxContainer/HPLabel
onready var level_label = $VBoxContainer/LevelLabel
onready var xp_label = $VBoxContainer/XPLabel

func _ready():
	player = autoload_transient.player
	if player : 
		player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats

func _process(delta):
	fps_label.set_text( str("FPS : ", Engine.get_frames_per_second()) )
	
	player = autoload_transient.player
	if is_instance_valid(player) : 
		player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats
		if is_instance_valid(player_current_stat) : 
			hp_label.set_text( str("ATK : ", player_current_stat.CurrentAttack) )
		#	level_label.set_text( str("LV : ", player_current_stat.CurrentLevel) )
		#	xp_label.set_text( str("EXP : ", player_current_stat.CurrentEXP) )
	pass
