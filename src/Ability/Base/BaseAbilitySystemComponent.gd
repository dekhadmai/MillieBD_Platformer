# Attach this to every actor who need to have stats or can interact with ability

class_name BaseAbilitySystemComponent
extends Node

# work around can't export character stats
export(float) var InitStat_HP = 100.0
export(float) var InitStat_Attack = 10.0
export(float) var InitStat_Movespeed = 150.0
export(float) var InitStat_JumpSpeed = 350.0
# end of work around can't export character stats

var BaseCharStats: CharacterStatsInit = CharacterStatsInit.new()
var CurrentCharStats: CharacterStats = CharacterStats.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	BaseCharStats.BaseHP = InitStat_HP
	BaseCharStats.BaseAttack = InitStat_Attack
	BaseCharStats.BaseMovespeed = InitStat_Movespeed
	BaseCharStats.BaseJumpSpeed = InitStat_JumpSpeed
	
	CurrentCharStats.InitBaseStat(BaseCharStats)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



##### Can't type cast here because cyclic dependency :(
func ApplyGameplayEffectToSelf(gameplay_effect):
	add_child(gameplay_effect)
	gameplay_effect.Activate(self, self)
	
	
