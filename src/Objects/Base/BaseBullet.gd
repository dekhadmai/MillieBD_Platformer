class_name BaseBullet
extends RigidBody2D

export(float) var BaseSpeed: float = 300.0

onready var animation_player = $AnimationPlayer
var gameplay_effect_template

onready var graze_effect = $GameplayEffect_GrazeXP
var graze_timer: Timer
var graze_actor: Actor
var graze_period: float = 0.05

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
	
func StartGraze(body:Actor):
	graze_actor = body
	graze_timer = Timer.new()
	add_child(graze_timer)
	graze_timer.connect("timeout", self, "OnBulletGraze")
	graze_timer.set_one_shot(false)
	graze_timer.start(graze_period)
	
func StopGraze():
	graze_timer.stop()
	
func OnBulletGraze():
	var effect:BaseGameplayEffect = graze_effect.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = graze_actor.GetAbilitySystemComponent()
	
	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
