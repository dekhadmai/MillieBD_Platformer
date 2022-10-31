extends Node


# Global reference. Read-only stuff. Use Autoload_TransientData for read-write/temp data

var PlayerWeaponAbilityTemplates = {
	"HandGun" : "res://src/Ability/Player/GameplayAbility_Weapon_HandGun.tscn",
	"Shotgun" : "res://src/Ability/Player/GameplayAbility_Weapon_Shotgun.tscn",
	"Minigun" : "res://src/Ability/Player/GameplayAbility_Weapon_Minigun.tscn"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
