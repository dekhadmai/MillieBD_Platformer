tool
extends Node2D

onready var graze_effect = $GameplayEffect_GrazeXP
onready var graze_vfx = $GrazeVfx
var graze_timer: Timer
var graze_actor: Actor
var graze_instigator: Actor
var graze_causer
export(float) var graze_exp_per_period = 1.0 setget set_graze_exp_per_period
export var graze_period: float = 0.05
export var bUseGrazeVfx = false

func set_graze_exp_per_period(val):
	graze_exp_per_period = val

func _ready():
	graze_effect.ValueToModify = graze_exp_per_period

func StartGraze(victim:Actor, instigator:Actor, causer):
	graze_actor = victim
	graze_instigator = instigator
	graze_causer = causer
	graze_timer = Timer.new()
	add_child(graze_timer)
	graze_timer.connect("timeout", self, "OnGraze")
	graze_timer.set_one_shot(false)
	graze_timer.start(graze_period)
	
func StopGraze():
	if graze_timer != null:
		graze_timer.stop()
	
func OnGraze():
	var effect:BaseGameplayEffect = graze_effect.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = graze_actor.GetAbilitySystemComponent()
	
	graze_instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	graze_actor.ShowGrazeVfx()
	
	if bUseGrazeVfx :
		graze_vfx.restart()
