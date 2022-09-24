class_name BaseArea2D
extends Area2D

signal OnEndAreaLinger

onready var graze_xp = $GrazeExpGiver
onready var anim_player = $AnimationPlayer

export var StartDamageAnimName: String = "area_start"
export var EndDamageAnimName: String = "area_end"
export var EndDamageAnimDuration: float = 0.25

onready var winddown_anim_timer: Timer = $WindDownAnimTimer

func _ready():
	if is_monitorable():
		if GetAnimPlayer() != null:
			GetAnimPlayer().play(StartDamageAnimName)
	
func GetAnimPlayer() -> AnimationPlayer:
	if anim_player == null:
		anim_player = get_node("AnimationPlayer")
	return anim_player

func GetOwnerObject() : 
	return GlobalFunctions.GetOwnerObject(self)

func StartGraze(victim_actor):
	graze_xp.StartGraze(victim_actor, GetOwnerObject().GetInstigator(), GetOwnerObject())

func StopGraze():
	graze_xp.StopGraze()

func SetActive(val: bool):
	if val : 
		GetAnimPlayer().play(StartDamageAnimName)
		set_visible(val)
	else : 
		var end_anim:Animation = GetAnimPlayer().get_animation(EndDamageAnimName)
		if EndDamageAnimDuration > 0 or end_anim != null or end_anim.length > 0 : 
			GetAnimPlayer().play(EndDamageAnimName)
			if EndDamageAnimDuration > 0 : 
				winddown_anim_timer.start(EndDamageAnimDuration)
			else:
				winddown_anim_timer.start(end_anim.length)
		else:
			set_visible(val)
			emit_signal("OnEndAreaLinger")
		
	set_monitorable(val)
	set_monitoring(val)
	
func _on_WindDownAnimTimer_timeout():
	set_visible(false)
	emit_signal("OnEndAreaLinger")

func _on_Area2D_HurtBox_area_entered(area):
	if area.get_collision_layer_bit(6) :
		var body = area.GetOwnerObject()
		if body.GetTeam() != GetOwnerObject().GetTeam():
			StartGraze(body)
	pass # Replace with function body.


func _on_Area2D_HurtBox_area_exited(area):
	if area.get_collision_layer_bit(6) :
		var body = area.GetOwnerObject()
		if body.GetTeam() != GetOwnerObject().GetTeam():
			StopGraze()
	pass # Replace with function body.
