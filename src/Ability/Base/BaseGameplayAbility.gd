class_name BaseGameplayAbility
extends Node2D


var AbilityOwner: Actor
var AnimPlayer: AnimationPlayerState
var AbilityCooldownTimer: Timer
export var AbilityCooldownSecond: float = 1.0
export var bCommitAbilityCooldownWhenDeactivate: bool = true
var bIsActive: bool

var bAlreadyInit: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if AbilityOwner == null:
		var try_owner = get_parent().get_parent()
		if try_owner is Actor:
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
	pass

# Always Use this one. Don't directly "Activate" ability
func TryActivate():
	if CanUseAbility():
		Activate()

func Activate():
	bIsActive = true
	pass
	
func Deactivate():
	if bCommitAbilityCooldownWhenDeactivate:
		CommitAbilityCooldown()
	bIsActive = false
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
	
func CanUseAbility() -> bool:
	return !IsAbilityOnCooldown()
	
func PlayCustomAnimation(custom_anim_name: String, seconds: float = 0.0):
	if AnimPlayer != null:
		AnimPlayer.PlayCustomAnim(custom_anim_name, seconds)
		
func getAnim() -> AnimationPlayerState:
	if AnimPlayer != null:
		return AnimPlayer
	else:
		print_debug('AnimPlayer not ready yet')
		return null
		
