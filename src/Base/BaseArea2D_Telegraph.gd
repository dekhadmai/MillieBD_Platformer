class_name BaseArea2D_Telegraph
extends BaseArea2D

export var TelegraphAnimName: String = "telegraph_loop"
export var TelegraphAnimDuration: float = 1.0

export var bStopTelegraphSoundWhenStopTelegraph = false
onready var telegraph_sound: AudioStreamPlayer2D = $TelegraphSound

onready var telegraph_timer: Timer = $TelegraphTimer
onready var area_linger_timer: Timer = $AreaLingerTimer
onready var effect_interval_timer: Timer = $EffectIntervalTimer
var affected_actors = []

export var AreaLingerDuration: float = 1.0
export var AreaEffectInterval: float = 0.0

signal OnHurtDetection(body)

func _on_TelegraphTimer_timeout():
	.SetActive(true)
	if bStopTelegraphSoundWhenStopTelegraph : 
		telegraph_sound.stop()
	pass # Replace with function body.


func SetActive(val: bool):
	if effect_interval_timer == null:
		effect_interval_timer = get_node("EffectIntervalTimer")
		
	if area_linger_timer == null:
		area_linger_timer = get_node("AreaLingerTimer")
		
	if val and TelegraphAnimDuration > 0 :
		set_visible(true)
		GetAnimPlayer().play(TelegraphAnimName)
		telegraph_sound.play()
		telegraph_timer.start(TelegraphAnimDuration)
	else:
		.SetActive(val)
		
	if !val:
		effect_interval_timer.stop()
		affected_actors.clear()
	else:
		area_linger_timer.start(AreaLingerDuration)
			
		if AreaEffectInterval > 0 :
			effect_interval_timer.start(AreaEffectInterval)

func OnHurtDetectionHit(body:Actor) :
	emit_signal("OnHurtDetection", body)


func _on_AreaLingerTimer_timeout():
	SetActive(false)


func _on_EffectIntervalTimer_timeout():
	for i in affected_actors.size() : 
		OnHurtDetectionHit(affected_actors[i])
	pass # Replace with function body.


func _on_Area2D_Damage_Telegraph_area_entered(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible > 0:
			if body.GetTeam() != GetOwnerObject().GetTeam():
				OnHurtDetectionHit(body)
				affected_actors.append(body)


func _on_Area2D_Damage_Telegraph_area_exited(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if body.GetTeam() != GetOwnerObject().GetTeam():
			affected_actors.erase(body)
