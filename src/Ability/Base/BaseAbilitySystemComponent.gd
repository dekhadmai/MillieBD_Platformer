# Attach this to every actor who need to have stats or can interact with ability

class_name BaseAbilitySystemComponent
extends Node2D

signal take_damage(value)
signal died
signal level_up

# work around can't export character stats
export(float) var InitStat_HP = 100.0
export(float) var InitStat_Attack = 100.0
export(float) var InitStat_Movespeed = 150.0
export(float) var InitStat_JumpSpeed = 370.0
export(float) var InitStat_IframeSeconds = 0.01
# end of work around can't export character stats

var BaseCharStats: CharacterStatsInit = CharacterStatsInit.new()
var CurrentCharStats: CharacterStats = CharacterStats.new()

onready var DamageNumberTemplate = preload("res://src/Ability/Base/DamageNumberTemplate.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(BaseCharStats)
	add_child(CurrentCharStats)
	
	BaseCharStats.BaseHP = InitStat_HP
	BaseCharStats.BaseAttack = InitStat_Attack
	BaseCharStats.BaseMovespeed = InitStat_Movespeed
	BaseCharStats.BaseJumpSpeed = InitStat_JumpSpeed
	
	CurrentCharStats.InitBaseStat(BaseCharStats, InitStat_IframeSeconds)
	var _error = CurrentCharStats.connect("died", self, "died")
	_error = CurrentCharStats.connect("level_up", self, "level_up")
	_error = CurrentCharStats.connect("take_damage", self, "take_damage")
	
	pass

func died():
	for n in get_children():
		if n.has_method("Deactivate") : 
			n.Deactivate()
		
	emit_signal("died")
	
func level_up():
	emit_signal("level_up")
	
func take_damage(value):
	var dmg_instance = DamageNumberTemplate.instance()
	dmg_instance.Init(self, value)
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
