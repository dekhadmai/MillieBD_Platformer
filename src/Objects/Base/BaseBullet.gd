class_name BaseBullet
extends RigidBody2D

export(float) var BaseSpeed: float = 500.0

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
		if body.Team_ID != Instigator.Team_ID:
			OnBulletHit(body)

func OnBulletHit(body:Actor):	
	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToSelf(effect)
	
	#body_asc.ApplyGameplayEffectToSelf(effect)
	
	body.destroy()
