class_name BaseGameplayAbility
extends Node2D


export var AbilityShortName:String = "AbiAbbv"
export var AbilityName:String = "AbiName"
export var AbilityDescription:String = "AbiDesc"
export var AbilityIcon:Texture

var AbilityOwner: Actor
var AnimPlayer: AnimationPlayerState
var AbilityCooldownTimer: Timer
export var AbilityCooldownSecond: float = 1.0
export var bCommitAbilityCooldownWhenDeactivate: bool = true
export var bUseFervor = false
export var FervorCost = 20.0
export var AbilityLevel: int = 0
export var AbilityMaxUseCount = 0
var AbilityUseCount = 0
var bIsActive: bool

var bAlreadyInit: bool = false

export var bStopMovingWhilePlayingAnim = true
export var CustomAnimName: String = ""
export var CustomAnimDuration: float = 0.1

export var FullbodyAnimName: String = ""
export var FullbodyAnimDuration: float = 0.1

export var LingeringAnimName: String = ""
export var LingeringAnimDuration: float = 1.0

export var AbilityDelayForAnimationSecond: float = 0.0
var AbilityDelayTimer: Timer

export var bUseAbilitySprite = false


onready var ability_sound = $AbilitySound
onready var GameplayeEffect_Template: BaseGameplayEffect = $GameplayEffectTemplate
onready var ability_sprite = $AbilitySprite

var TargetActor:Actor = null setget SetTargetActor

var bStopMovingAnim: bool
var StopMovingAnimTimer:Timer

var CacheGravity

func GetAbilityLevel() -> int :
	return AbilityLevel

func SetTargetActor(target:Actor):
	TargetActor = target
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if AbilityOwner == null:
		var try_owner = get_parent().get_parent()
		if try_owner.get_class() == "Actor":
			AbilityOwner = try_owner
			
	if AbilityOwner != null:
		AnimPlayer = AbilityOwner.find_node("AnimationPlayerState")
		AbilityCooldownTimer = get_node("AbilityCooldown")
		AbilityCooldownTimer.set_one_shot(true)
		
		if !bAlreadyInit:
			Init()
		
	pass # Replace with function body.

##### Main/Stub functions

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Init():
	bAlreadyInit = true
	
	if GameplayeEffect_Template == null:
		GameplayeEffect_Template = get_node("GameplayEffectTemplate")
		
	if ability_sound == null:
		ability_sound = get_node("AbilitySound")
		
	if StopMovingAnimTimer == null :
		StopMovingAnimTimer = GlobalFunctions.CreateTimerAndBind(self, self, "StopMovingAnimTimer_timeout")
		StopMovingAnimTimer.set_one_shot(true)
		
	if AbilityDelayTimer == null:
		AbilityDelayTimer = GlobalFunctions.CreateTimerAndBind(self, self, "AbilityDelayTimer_timeout")
		AbilityDelayTimer.set_one_shot(true)
		
	pass

# Always Use this one. Don't directly "Activate" ability
func TryActivate():
	if CanUseAbility():
		Activate()

func Activate():
	if bUseFervor:
		AbilityOwner.GetAbilitySystemComponent().CurrentCharStats.AddFervor(-FervorCost)
	bIsActive = true
	if bUseAbilitySprite : 
		ability_sprite.set_visible(true)
	
	if CustomAnimName != "":
		PlayCustomAnimation(CustomAnimName, CustomAnimDuration, bStopMovingWhilePlayingAnim)
		
	if FullbodyAnimName != "":
		PlayFullBodyAnimation(FullbodyAnimName, FullbodyAnimDuration, bStopMovingWhilePlayingAnim)
		
	SetLingeringAnimation(LingeringAnimName, LingeringAnimDuration)
	
	if AbilityDelayForAnimationSecond > 0 : 
		AbilityDelayTimer.start(AbilityDelayForAnimationSecond)
	else:
		DoAbility()
			
	if AbilityMaxUseCount > 0 : 
		AbilityUseCount += 1
	pass
	
func DoAbility():
	ability_sound.play()
	pass

func Deactivate():
	if bCommitAbilityCooldownWhenDeactivate:
		CommitAbilityCooldown()
	bIsActive = false
	if bUseAbilitySprite : 
		ability_sprite.set_visible(false)
	pass
	
func EndAbility():
	Deactivate()

##### Helper functions

func CommitAbilityCooldown():
	AbilityCooldownTimer.start(AbilityCooldownSecond)
	
func IsAbilityOnCooldown() -> bool:
	return !AbilityCooldownTimer.is_stopped()
	
func IsAbilityActive() -> bool:
	return bIsActive
	
func GetAbilityRemainingCooldownSeconds() -> float:
	return AbilityCooldownTimer.get_time_left()
	
func CanUseAbility() -> bool:
	var result = true
	if AbilityMaxUseCount > 0 and AbilityUseCount >= AbilityMaxUseCount : 
		return false
	
	if bUseFervor :
		result = result and AbilityOwner.GetAbilitySystemComponent().CurrentCharStats.CurrentFervor >= FervorCost
	result = result and !IsAbilityOnCooldown() and !bIsActive and !AbilityOwner.bIsDead
	return  result

func SetLingeringAnimation(lingering_anim_name: String, seconds: float = 0.0):
	if AnimPlayer != null:
		AnimPlayer.SetLingeringAnim(lingering_anim_name, seconds)

func PlayCustomAnimation(custom_anim_name: String, seconds: float = 0.0, bStopMovingWhilePlayingAnim = false):
	if custom_anim_name == "":
		return
		
	if AnimPlayer != null:
		AnimPlayer.PlayCustomAnim(custom_anim_name, seconds)
		
	if bStopMovingWhilePlayingAnim:
		bStopMovingAnim = bStopMovingWhilePlayingAnim
		CacheGravity = AbilityOwner.bUseGravity
		AbilityOwner.bUseGravity = false
		AbilityOwner.bDontMoveStack += 1
		StopMovingAnimTimer.start(seconds)
		
func PlayFullBodyAnimation(fullbody_anim_name: String, seconds: float = 0.0, bStopMovingWhilePlayingAnim = false):
	if fullbody_anim_name == "":
		return
	
	if AnimPlayer != null:
		AnimPlayer.PlayFullBodyAnim(fullbody_anim_name, seconds)
		
	if bStopMovingWhilePlayingAnim:
		bStopMovingAnim = bStopMovingWhilePlayingAnim
		CacheGravity = AbilityOwner.bUseGravity
		AbilityOwner.bUseGravity = false
		AbilityOwner.bDontMoveStack += 1
		StopMovingAnimTimer.start(seconds)
		
func getAnim() -> AnimationPlayerState:
	if AnimPlayer != null:
		return AnimPlayer
	else:
		print_debug('AnimPlayer not ready yet')
		return null
		
func StopMovingAnimTimer_timeout():
	AbilityOwner.bDontMoveStack -= 1
	AbilityOwner.bUseGravity = CacheGravity
	
func AbilityDelayTimer_timeout():
	DoAbility()
