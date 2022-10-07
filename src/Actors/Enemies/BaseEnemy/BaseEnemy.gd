class_name Enemy
extends Actor


enum State {
	MOVING,
	DEAD,
}

var _state = State.MOVING

const OriginalScale = 0.25

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayerState
onready var autoload_transient = $"/root/AutoLoadTransientData"

export var AIcontroller_NodeName = "AIController"
onready var ai_controller

onready var hp_bar = $Hpbar
onready var hp_value = $Hpvalue

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	speed.x = GetAbilitySystemComponent().CurrentCharStats.BaseMovespeed
	speed.y = GetAbilitySystemComponent().CurrentCharStats.BaseJumpSpeed
	_velocity.x = speed.x
	CurrentTargetActor = autoload_transient.player
	
	sprite.scale.x = OriginalScale
	sprite.scale.y = OriginalScale
	
	if ai_controller == null:
		ai_controller = get_node(AIcontroller_NodeName)
		if ai_controller == null:
			print("Can't Find AIController NodeName=" + AIcontroller_NodeName + ", self=" + str(self))
	
	if ai_controller != null : 
		ai_controller.init(self)

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
	if is_instance_valid(CurrentTargetActor):
		CurrentTargetActor = autoload_transient.player
	
	var abi_comp = GetAbilitySystemComponent()
	if abi_comp :
		hp_bar.set_max(abi_comp.CurrentCharStats.BaseHP)
		hp_bar.set_value(abi_comp.CurrentCharStats.CurrentHP)
		hp_value.set_text(str(abi_comp.CurrentCharStats.CurrentHP))
		
	
	if ai_controller != null : 
		ai_controller.update_physics(_delta)
		
	# We flip the Sprite depending on which way the enemy is moving.
	if _velocity.x > 0:
		sprite.scale.x = -OriginalScale
	else:
		sprite.scale.x = OriginalScale
		
	FacingDirection = -sprite.scale.x / OriginalScale

	UpdateAnimState()
#	var animation = get_new_animation()
#	if animation != animation_player.current_animation:
#		animation_player.play(animation)

func died():
	.died()
	destroy()

func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO

func UpdateAnimState():
	var animation_new = ""
	
	if _state != State.DEAD :
		if is_on_floor():
			if abs(_velocity.x) > 0.1:
				animation_new = "walk"
			else:
				animation_new = "idle"
		else:
			if abs(_velocity.x) > 0.1 or abs(_velocity.y) > 0:
				animation_new = "walk"
			else:
				animation_new = "idle"
	else : 
		animation_new = "death"
	
	if animation_player != null : 
		animation_player.BaseAnimState = animation_new
	
func get_new_animation():
	return ""
