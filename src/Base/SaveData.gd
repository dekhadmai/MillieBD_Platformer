class_name SaveData
extends Node

export var BaseHP: float
export var BaseAttack: float
export var BaseMovespeed: float
export var BaseJumpSpeed: float
export var DeathCount: int = 0
export var Level: int = 0
export var CurrentEXP: int = 0

export(Array, String) var WeaponAbilityTemplateNameArray
export(Array, String) var SpecialAbilityTemplateNameArray


func GetSaveData() : 
	var json = {
		"BaseHP" : BaseHP,
		"BaseAttack" : BaseAttack,
		"BaseMovespeed" : BaseMovespeed,
		"BaseJumpSpeed" : BaseJumpSpeed,
		"DeathCount" : DeathCount,
		"Level" : Level,
		"CurrentEXP" : CurrentEXP,
		"WeaponAbilityTemplateNameArray" : WeaponAbilityTemplateNameArray,
		"SpecialAbilityTemplateNameArray" : SpecialAbilityTemplateNameArray
	}
	return json
	
func LoadData(data) : 
	BaseHP = data.BaseHP
	BaseAttack = data.BaseAttack
	BaseMovespeed = data.BaseMovespeed
	BaseJumpSpeed = data.BaseJumpSpeed
	DeathCount = data.DeathCount
	Level = data.Level
	CurrentEXP = data.CurrentEXP
	WeaponAbilityTemplateNameArray = data.WeaponAbilityTemplateNameArray
	SpecialAbilityTemplateNameArray = data.SpecialAbilityTemplateNameArray
