extends "res://src/Ability/Player/GameplayAbility_Weapon_Shotgun.gd"

var CurrentBulletCount = 0
export var BulletClip = 10
export var ReloadCooldown = 3.0

var ReloadTimer: Timer
var is_reloading = false

func _ready():
	ReloadTimer = GlobalFunctions.CreateTimerAndBind(self, self, "OnReloadTimerEnd")
	
func OnReloadTimerEnd():
	is_reloading = false
	CurrentBulletCount = 0
	
func IsAbilityOnCooldown() -> bool:
	return !ReloadTimer.is_stopped() or .IsAbilityOnCooldown()
	
func GetAbilityRemainingCooldownSeconds() -> float:
	if ReloadTimer.is_stopped() : 
		return .GetAbilityRemainingCooldownSeconds()
	else : 
		return ReloadTimer.get_time_left()

func OnSpawnBullet(bullet):
	CurrentBulletCount += 1
	if CurrentBulletCount >= BulletClip : 
		is_reloading = true
		ReloadTimer.start(ReloadCooldown)
	pass
