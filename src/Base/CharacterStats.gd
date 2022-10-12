class_name CharacterStats
extends CharacterStatsInit

signal take_damage(damage)
signal died
signal level_up

# Add to the back only, DO NOT ADD TO THE FRONT, It will shift everything that is already in the game by +1
enum CharacterStatType {None, Damage, HP, Attack, MoveSpeed, EXP, Fever, ExpAdjustScale}

var HurtIframeTimer:Timer
var HurtIframeDuration = 1.0
var bHurtIframe: bool = false

var bInvincible: bool = false setget SetInvincible
var CurrentHP: float = 0.0
var CurrentAttack: float = 0.0
var CurrentMovespeed: float = 0.0
var CurrentJumpSpeed: float = 0.0
var CurrentLevel: int = 1
var CurrentEXP: float = 0.0
var MaxEXP: float = 100.0
var TotalDamageAdjustScale: float = 1.0
var AttackScale: float = 1.0 setget SetAttackScale
var AttackScaleMultiplicative: float = 1.0 setget SetAttackScaleMultiplicative
var MovespeedScale: float = 1.0 setget SetMovespeedScale
var MovespeedScaleMultiplicative: float = 1.0 setget SetMovespeedScaleMultiplicative
var DamageAdjustScale: float = 1.0 setget SetDamageAdjustScale
var DamageAdjustScaleMultiplicative: float = 1.0 setget SetDamageAdjustScaleMultiplicative
var ExpAdjustScale: float = 1.0
var CooldownReductionScale: float = 1.0 setget SetCooldownReductionScale

func InitBaseStat(init_stat: CharacterStatsInit, IframeSeconds: float) -> void:
	HurtIframeDuration = IframeSeconds
	HurtIframeTimer = Timer.new()
	add_child(HurtIframeTimer)
	HurtIframeTimer.set_one_shot(true)
	HurtIframeTimer.connect("timeout", self, "HurtIframeTimer_timeout")
	
	BaseHP = init_stat.BaseHP
	BaseAttack = init_stat.BaseAttack
	BaseMovespeed = init_stat.BaseMovespeed
	BaseJumpSpeed = init_stat.BaseJumpSpeed
	
	CurrentHP = BaseHP
	
	Calculate()
	

func Calculate() -> void: 
	CurrentAttack = (BaseAttack * AttackScale) * AttackScaleMultiplicative
	CurrentMovespeed = (BaseMovespeed * MovespeedScale) * MovespeedScaleMultiplicative
	CurrentJumpSpeed = BaseJumpSpeed
	TotalDamageAdjustScale = DamageAdjustScale * DamageAdjustScaleMultiplicative
	
func HurtIframeTimer_timeout():
	bHurtIframe = false
	 
func SetInvincible(value: bool):
	bInvincible = value

func TakeDamage(value: float):
	if bHurtIframe or bInvincible : 
		return
	
	CurrentHP -= value
	emit_signal("take_damage", value)
	bHurtIframe = true
	HurtIframeTimer.start(HurtIframeDuration)
	
	if CurrentHP <= 0.0:
		CurrentHP = 0.0
		emit_signal("died")
	
	#todo add more stuff about character death here

func AddEXP(value: float):
	CurrentEXP += (value * ExpAdjustScale)
	if CurrentEXP >= MaxEXP:
		CurrentEXP -= MaxEXP
		CurrentLevel += 1
		emit_signal("level_up")

func SetAttackScale(value: float):
	AttackScale = value
	Calculate()
	
func SetAttackScaleMultiplicative(value: float):
	AttackScaleMultiplicative = value
	Calculate()
	
func SetMovespeedScale(value: float):
	MovespeedScale = value
	Calculate()
	
func SetMovespeedScaleMultiplicative(value: float):
	MovespeedScaleMultiplicative = value
	Calculate()
	
func SetDamageAdjustScale(value: float):
	DamageAdjustScale = value
	Calculate()
	
func SetDamageAdjustScaleMultiplicative(value: float):
	DamageAdjustScaleMultiplicative = value
	Calculate()
	
func SetCooldownReductionScale(value: float):
	CooldownReductionScale = value
	Calculate()
