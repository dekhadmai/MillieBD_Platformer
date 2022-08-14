class_name BaseBullet
extends RigidBody2D

export(float) var BaseSpeed: float = 300.0

onready var animation_player = $AnimationPlayer
var gameplay_effect_template

var Instigator:Actor

func Init(instigator:Actor, gameplayeffect_template:BaseGameplayEffect):
	Instigator = instigator
	gameplay_effect_template = gameplayeffect_template
	

func destroy():
	animation_player.play("destroy")


func _on_body_entered(body):
	if body is Actor:
		if body.GetTeam() != Instigator.GetTeam():
			OnBulletHit(body)
	else :
		queue_free()

func OnBulletHit(body:Actor):	
	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	
	#body.destroy()
	queue_free()
	
