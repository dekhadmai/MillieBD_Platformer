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
	
	pass

func on_timeout_effect_duration():
	Deactivate()

func Deactivate():
	UndoEffect()
	queue_free()
	pass


func DoEffect() -> void:
	match StatToModify:
		CharacterStats.CharacterStatType.Damage:
			TargetAbilitySystemComponent.CurrentCharStats.TakeDamage(ValueToModify)
		CharacterStats.CharacterStatType.EXP:
			TargetAbilitySystemComponent.CurrentCharStats.SetEXP(TargetAbilitySystemComponent.CurrentCharStats.CurrentEXP + ValueToModify)
		_:
			pass

func UndoEffect() -> void:
	# todo : add more stuff here when we have other stat we want to buff
	pass
