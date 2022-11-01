extends Node


# Global reference. Read-only stuff. Use Autoload_TransientData for read-write/temp data

var PlayerWeaponAbilityTemplates = {
	"HandGun" : "res://src/Ability/Player/GameplayAbility_Weapon_HandGun.tscn",
	"Shotgun" : "res://src/Ability/Player/GameplayAbility_Weapon_Shotgun.tscn",
	"Minigun" : "res://src/Ability/Player/GameplayAbility_Weapon_Minigun.tscn"
}

var PlayerSpecialAbilityTemplates = {
	"SlowTime" : "res://src/Ability/Player/GameplayAbility_SlowTime.tscn",
	"Heal" : "res://src/Ability/Player/GameplayAbility_Heal.tscn",
	"Invincible" : "res://src/Ability/Player/GameplayAbility_Invincible.tscn",
	"AttackBuff" : "res://src/Ability/Player/GameplayAbility_AttackBuff.tscn",
	"DamageReductionBuff" : "res://src/Ability/Player/GameplayAbility_DamageReductionBuff.tscn",
	"Beam" : "res://src/Ability/Player/GameplayAbility_Player_Beam.tscn"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
