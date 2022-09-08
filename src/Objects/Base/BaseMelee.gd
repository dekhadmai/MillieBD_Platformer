class_name BaseMelee
extends RigidBody2D

onready var animation_player = $AnimationPlayer
onready var graze_xp = $GrazeExpGiver
var gameplay_effect_template

var Instigator:Actor

func Init(instigator:Actor, gameplayeffect_template:BaseGameplayEffect):
	Instigator = instigator
	gameplay_effect_template = gameplayeffect_template
	

func destroy():
	animation_player.play("destroy")


func _on_body_entered(body):
	OnBodyEnter(body)

func OnBodyEnter(body):
		if body is Actor:
			if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible:
				#if body.GetTeam() != Instigator.GetTeam():
					OnBulletHit(body)
		else :
			queue_free()

func OnBulletHit(body:Actor):	
#	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
#	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
#
#	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
#
#	#body.destroy()
#	queue_free()
	pass
	
func StartGraze(body:Actor):
	graze_xp.StartGraze(body, Instigator, self)
	
func StopGraze():
	graze_xp.StopGraze()

func play(anim_name):
	if animation_player == null:
		animation_player = find_node("AnimationPlayer")
	animation_player.play(anim_name)
