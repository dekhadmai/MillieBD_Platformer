class_name BaseGameplayEffect
extends Node

enum DurationType {Instant, HasDuration, Infinite}

export(DurationType) var EffectDurationType
export(float) var EffectDuration
export(CharacterStats.CharacterStatType) var StatToModify
export(float) var ValueToModify

var InstigatorAbilitySystemComponent
var TargetAbilitySystemComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func Activate(instigator, target) -> void:
	InstigatorAbilitySystemComponent = instigator
	TargetAbilitySystemComponent = target
	pass
