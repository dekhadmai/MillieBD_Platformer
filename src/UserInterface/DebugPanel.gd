extends Panel

onready var autoload_transient = $"/root/AutoLoadTransientData"
var player: Actor
var player_current_stat: CharacterStats

onready var fps_label = $VBoxContainer/FPSLabel
onready var hp_label = $VBoxContainer/HPLabel
onready var level_label = $VBoxContainer/LevelLabel
onready var xp_label = $VBoxContainer/XPLabel

var time_start = 0
var time_now = 0

func _ready():
	player = autoload_transient.player
	if player : 
		player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats
		
	time_start = OS.get_unix_time()

func _process(_delta):
	fps_label.set_text( str("FPS : ", Engine.get_frames_per_second()) )
	
#	player = autoload_transient.player
#	if is_instance_valid(player) : 
#		player_current_stat = player.GetAbilitySystemComponent().CurrentCharStats
#		if is_instance_valid(player_current_stat) : 
#			hp_label.set_text( str("ATK : ", player_current_stat.CurrentAttack) )
#		#	level_label.set_text( str("LV : ", player_current_stat.CurrentLevel) )
#		#	xp_label.set_text( str("EXP : ", player_current_stat.CurrentEXP) )
		
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	if hp_label : 
		hp_label.set_text( str_elapsed )
	
	pass
