extends Node


# Global reference. Read-only stuff. Use Autoload_TransientData for read-write/temp data

var PlayerWeaponAbilityTemplates = {
	"HandGun" : "res://src/Ability/Player/GameplayAbility_Weapon_HandGun.tscn",
	"Shotgun" : "res://src/Ability/Player/GameplayAbility_Weapon_Shotgun.tscn",
	"Minigun" : "res://src/Ability/Player/GameplayAbility_Weapon_Minigun.tscn"
}

var PlayerSpecialAbilityTemplates = {
	"SlowTime" : "res://src/Ability/Player/GameplayAbility_SlowTime.tscn",
	"Invincible" : "res://src/Ability/Player/GameplayAbility_Invincible.tscn",
	"AttackBuff" : "res://src/Ability/Player/GameplayAbility_AttackBuff.tscn",
	"Shield" : "res://src/Ability/Player/GameplayAbility_DamageReductionBuff.tscn",
	"Beam" : "res://src/Ability/Player/GameplayAbility_Player_Beam.tscn",
	"Nuke" : "res://src/Ability/Player/GameplayAbility_Projectile_Nuke.tscn",
	"Homing" : "res://src/Ability/Player/GameplayAbility_HomingSwarm.tscn"
}
#"Heal" : "res://src/Ability/Player/GameplayAbility_Heal.tscn",

var IconResource = {
	"HandGun" : "res://assets/art/ui/icons/Handgun.png",
	"Shotgun" : "res://assets/art/ui/icons/Shotgun.png",
	"Minigun" : "res://assets/art/ui/icons/Minigun.png",
	"SlowTime" : "res://assets/art/ui/icons/Slowtime.png",
	"Heal" : "res://assets/art/ui/icons/Heal.png",
	"Invincible" : "res://assets/art/ui/icons/Invincible.png",
	"AttackBuff" : "res://assets/art/ui/icons/AttackUp.png",
	"Shield" : "res://assets/art/ui/icons/DamageReduced.png",
	"Beam" : "res://assets/art/ui/icons/Beam.png",
	"Nuke" : "res://assets/art/ui/icons/Nuke.png",
	"Homing" : "res://assets/art/ui/icons/Homing.png",
	"Dash" : "res://assets/art/ui/icons/dash.png",
	"Float" : "res://assets/art/ui/icons/dash_icon_2.png"
}

var SfxResource = {
	"Heal" : "res://assets/audio/sfx/More sfx/millie ability sfx/heal.wav",
	"Checkpoint" : "res://assets/audio/sfx/More sfx/interaction/SaveTotemSFX.wav",
	"RoomClear" : "res://assets/audio/sfx/More sfx/interaction/DungeonClearSFX.wav",
	"DiscordJoin" : "res://assets/audio/sfx/UI/Dialog/Discord Join.wav",
	"DiscordNotif" : "res://assets/audio/sfx/UI/Dialog/Discord notification.wav",
	"EnnaBitch" : "res://assets/audio/sfx/UI/Dialog/fucking_bitch_midi.mp3",
	"crash" : "res://assets/audio/sfx/UI/Dialog/crash.wav",
	"magicsfx" : "res://assets/audio/sfx/UI/Dialog/magicsfx.wav"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
