class_name BaseGameplayEffect
extends Node2D

enum DurationType {Instant, HasDuration, Infinite}

export(DurationType) var EffectDurationType
export(float) var EffectDuration
export(CharacterStats.CharacterStatType) var StatToModify
export(float) var ValueToModify

var InstigatorAbilitySystemComponent: BaseAbilitySystemComponent
var TargetAbilitySystemComponent: BaseAbilitySystemComponent

var EffectDurationTimer: Timer

onready var effect_sprite = $GameplayEffectSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func Activate(instigator_ability_system_component, target_ability_system_component) -> void:
	InstigatorAbilitySystemComponent = instigator_ability_system_component
	TargetAbilitySystemComponent = target_ability_system_component
	DoEffect()
	
	if EffectDurationType == DurationType.Instant:
		Deactivate()
	elif EffectDurationType == DurationType.HasDuration:
		EffectDurationTimer = Timer.new()
		add_child(EffectDurationTimer)
		EffectDurationTimer.connect("timeout", self, "on_timeout_effect_duration")
		EffectDurationTimer.set_one_shot(true)
		EffectDurationTimer.start(EffectDuration)
		
		if effect_sprite : 
			effect_sprite.set_visible(true)
	
	pass

func on_timeout_effect_duration():
	Deactivate()

func Deactivate():
	UndoEffect()
	if effect_sprite : 
		effect_sprite.set_visible(false) 
	queue_free()
	pass


func DoEffect() -> void:
	var instigator_stat = InstigatorAbilitySystemComponent.CurrentCharStats
	var target_stat = TargetAbilitySystemComponent.CurrentCharStats
	match StatToModify:
		CharacterStats.CharacterStatType.Damage:
			var calc_value = (ValueToModify * instigator_stat.CurrentAttack/100.0) * target_stat.TotalDamageAdjustScale
			TargetAbilitySystemComponent.CurrentCharStats.TakeDamage(calc_value)
		CharacterStats.CharacterStatType.EXP:
			TargetAbilitySystemComponent.CurrentCharStats.AddEXP(ValueToModify)
		CharacterStats.CharacterStatType.ExpAdjustScale:
			TargetAbilitySystemComponent.CurrentCharStats.ExpAdjustScale += ValueToModify
		CharacterStats.CharacterStatType.HP:
			TargetAbilitySystemComponent.CurrentCharStats.CurrentHP += ValueToModify
		CharacterStats.CharacterStatType.bInvincible:
			TargetAbilitySystemComponent.CurrentCharStats.bInvincible += ValueToModify
		CharacterStats.CharacterStatType.DamageAdjustScale:
			TargetAbilitySystemComponent.CurrentCharStats.DamageAdjustScale += ValueToModify
		CharacterStats.CharacterStatType.AttackScale:
			TargetAbilitySystemComponent.CurrentCharStats.AttackScale += ValueToModify
		_:
			pass

func UndoEffect() -> void:
	match StatToModify:
		CharacterStats.CharacterStatType.ExpAdjustScale:
			TargetAbilitySystemComponent.CurrentCharStats.ExpAdjustScale -= ValueToModify
		CharacterStats.CharacterStatType.bInvincible:
			TargetAbilitySystemComponent.CurrentCharStats.bInvincible -= ValueToModify
		CharacterStats.CharacterStatType.DamageAdjustScale:
			TargetAbilitySystemComponent.CurrentCharStats.DamageAdjustScale -= ValueToModify
		CharacterStats.CharacterStatType.AttackScale:
			TargetAbilitySystemComponent.CurrentCharStats.AttackScale -= ValueToModify
		_:
			pass
	pass
