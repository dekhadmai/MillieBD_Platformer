class_name BaseBullet
extends RigidBody2D

export(float) var BaseSpeed: float = 300.0

onready var animation_player = $AnimationPlayer
var gameplay_effect_template

var Instigator:Actor

func get_class():
	return "BaseBullet"
	
func GetTeam():
	return Instigator.GetTeam()
	
func GetInstigator() -> Actor:
	return Instigator

func Init(instigator:Actor, gameplayeffect_template:BaseGameplayEffect):
	Instigator = instigator
	gameplay_effect_template = gameplayeffect_template
	

func destroy():
	animation_player.play("destroy")


func _on_body_entered(body):
	OnBodyEnter(body)

func OnBodyEnter(body):
	queue_free()

func OnBulletHit(body:Actor):	
	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	
	#body.destroy()
	queue_free()
	pass


func _on_Area2D_Damage_area_entered(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible:
			if body.GetTeam() != GetTeam():
				#print(str(body) + "=" + str(body.GetTeam()) + ", " + str(Instigator) + "=" + str(GetTeam()))
				OnBulletHit(body)
	pass # Replace with function body.
