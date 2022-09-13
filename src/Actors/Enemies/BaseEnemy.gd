class_name Enemy
extends Actor


enum State {
	MOVING,
	DEAD,
}

var _state = State.MOVING

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var autoload_transient = $"/root/AutoLoadTransientData"

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	speed.x = GetAbilitySystemComponent().CurrentCharStats.BaseMovespeed
	speed.y = GetAbilitySystemComponent().CurrentCharStats.BaseJumpSpeed
	_velocity.x = speed.x
	CurrentTargetActor = autoload_transient.player

# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# At a glance, you can see that the physics process loop:
# 1. Calculates the move velocity.
# 2. Moves the character.
# 3. Updates the sprite direction.
# 4. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	# We flip the Sprite depending on which way the enemy is moving.
	if _velocity.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
		
	FacingDirection = sprite.scale.x

	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)

func died():
	.died()
	destroy()

func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO


func get_new_animation():
	pass
