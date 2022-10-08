# Attach this to every actor who need to have stats or can interact with ability

class_name BaseAbilitySystemComponent
extends Node2D

signal take_damage(value)
signal died

# work around can't export character stats
export(float) var InitStat_HP = 100.0
export(float) var InitStat_Attack = 10.0
export(float) var InitStat_Movespeed = 150.0
export(float) var InitStat_JumpSpeed = 370.0
export(float) var InitStat_IframeSeconds = 0.01
# end of work around can't export character stats

var BaseCharStats: CharacterStatsInit = CharacterStatsInit.new()
var CurrentCharStats: CharacterStats = CharacterStats.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(BaseCharStats)
	add_child(CurrentCharStats)
	
	BaseCharStats.BaseHP = InitStat_HP
	BaseCharStats.BaseAttack = InitStat_Attack
	BaseCharStats.BaseMovespeed = InitStat_Movespeed
	BaseCharStats.BaseJumpSpeed = InitStat_JumpSpeed
	
	CurrentCharStats.InitBaseStat(BaseCharStats, InitStat_IframeSeconds)
	CurrentCharStats.connect("died", self, "died")
	CurrentCharStats.connect("take_damage", self, "take_damage")
	
	pass

func died():
	emit_signal("died")
	
func take_damage(value):
	emit_signal("take_damage", value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



##### Can't type cast here because cyclic dependency :(
func ApplyGameplayEffectToSelf(gameplay_effect):
	add_child(gameplay_effect)
	gameplay_effect.Activate(self, self)
	
func ApplyGameplayEffectToTarget(target_ability_system_component, gameplay_effect):
	add_child(gameplay_effect)
	gameplay_effect.Activate(self, target_ability_system_component)
