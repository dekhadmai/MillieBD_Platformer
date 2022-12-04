class_name BaseGameplayEffect
extends Node2D

enum DurationType {Instant, HasDuration, Infinite}

export var bExpAddFerver = true
export(DurationType) var EffectDurationType
export(float) var EffectDuration
export(CharacterStats.CharacterStatType) var StatToModify
export(float) var ValueToModify

var InstigatorAbilitySystemComponent: BaseAbilitySystemComponent
var TargetAbilitySystemComponent: BaseAbilitySystemComponent

var EffectDurationTimer: Timer
var EffectFadeOutTimer: Timer

export var SpriteFadeOutDuration = 0.5
var bStartFadeout = false
var current_modulate:Color

var effect_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	effect_sprite = find_node("GameplayEffectSprite")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if effect_sprite and bStartFadeout :
		current_modulate = effect_sprite.get_modulate()
		current_modulate.a -= delta / SpriteFadeOutDuration
		effect_sprite.set_modulate(current_modulate)
	pass


func Activate(instigator_ability_system_component, target_ability_system_component) -> void:
	InstigatorAbilitySystemComponent = instigator_ability_system_component
	TargetAbilitySystemComponent = target_ability_system_component
	DoEffect()
	
	if EffectDurationType == DurationType.Instant:
		Deactivate()
	elif EffectDurationType == DurationType.HasDuration:
		EffectDurationTimer = GlobalFunctions.CreateTimerAndBind(self, self, "on_timeout_effect_duration")
		EffectDurationTimer.start(EffectDuration)
		
		EffectFadeOutTimer = GlobalFunctions.CreateTimerAndBind(self, self, "on_timeout_effect_fadeout")
		EffectFadeOutTimer.start(EffectDuration-SpriteFadeOutDuration)
		
		if effect_sprite : 
			effect_sprite.set_visible(true)
	
	pass

func on_timeout_effect_fadeout():
	bStartFadeout = true
	
func on_timeout_effect_duration():
	Deactivate()

func Deactivate():
	if EffectDurationType != DurationType.Instant:
		UndoEffect()
	if effect_sprite : 
		effect_sprite.set_visible(false) 
		bStartFadeout = false
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
			if bExpAddFerver :
				TargetAbilitySystemComponent.CurrentCharStats.AddFervor(ValueToModify)
		CharacterStats.CharacterStatType.Ferver:
			TargetAbilitySystemComponent.CurrentCharStats.AddFervor(ValueToModify)
		CharacterStats.CharacterStatType.ExpAdjustScale:
			TargetAbilitySystemComponent.CurrentCharStats.ExpAdjustScale += ValueToModify
		CharacterStats.CharacterStatType.HP:
			TargetAbilitySystemComponent.CurrentCharStats.CurrentHP += ValueToModify
		CharacterStats.CharacterStatType.MaxHP:
			TargetAbilitySystemComponent.CurrentCharStats.AddBaseHP(ValueToModify)
		CharacterStats.CharacterStatType.Attack:
			TargetAbilitySystemComponent.CurrentCharStats.AddBaseAtk(ValueToModify)
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
