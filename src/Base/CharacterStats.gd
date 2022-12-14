class_name CharacterStats
extends CharacterStatsInit

enum CharacterStatType {None, Damage, HP, Attack, MoveSpeed}

var CurrentHP: float = 0.0 setget TakeDamage
var CurrentAttack: float = 0.0
var CurrentMovespeed: float = 0.0
var TotalDamageAdjustScale: float = 1.0
var AttackScale: float = 1.0 setget SetAttackScale
var AttackScaleMultiplicative: float = 1.0 setget SetAttackScaleMultiplicative
var MovespeedScale: float = 1.0 setget SetMovespeedScale
var MovespeedScaleMultiplicative: float = 1.0 setget SetMovespeedScaleMultiplicative
var DamageAdjustScale: float = 1.0 setget SetDamageAdjustScale
var DamageAdjustScaleMultiplicative: float = 1.0 setget SetDamageAdjustScaleMultiplicative
var CooldownReductionScale: float = 1.0 setget SetCooldownReductionScale

func InitBaseStat(init_stat: CharacterStatsInit) -> void:
	BaseHP = init_stat.BaseHP
	BaseAttack = init_stat.BaseAttack
	BaseMovespeed = init_stat.BaseMovespeed
	
	CurrentHP = BaseHP
	
	Calculate()
	

func Calculate() -> void: 
	CurrentAttack = (BaseAttack * AttackScale) * AttackScaleMultiplicative
	CurrentMovespeed = (BaseMovespeed * MovespeedScale) * MovespeedScaleMultiplicative
	TotalDamageAdjustScale = DamageAdjustScale * DamageAdjustScaleMultiplicative
	
func TakeDamage(value: float):
	CurrentHP -= value
	#todo add more stuff about character death here

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
