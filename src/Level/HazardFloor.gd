extends Node2D

onready var gameplay_effect_template = $GameplayEffectTemplate
onready var ability_system_component = $AbilitySystemComponent

func OnBulletHit(body:Actor):	
	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	ability_system_component.ApplyGameplayEffectToTarget(body_asc, effect)


func _on_Area2D_area_entered(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible:
			#print(str(body) + "=" + str(body.GetTeam()) + ", " + str(Instigator) + "=" + str(GetTeam()))
			OnBulletHit(body)
