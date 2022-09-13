class_name GroundedEnemy
extends Enemy

onready var ai_controller = $AIControllerGrounded
onready var shoot_abi = $AbilitySystemComponent/ShootAbility


# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
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
	if ai_controller != null : 
		ai_controller.update_physics(_delta)


func get_new_animation():
	var animation_new = ""
	if _state == State.MOVING:
		if _velocity.x == 0:
			animation_new = "idle"
		else:
			animation_new = "walk"
	else:
		animation_new = "destroy"
	return animation_new


func _on_ShootTimer_timeout():
	# only shoot if the player is in range
	if ai_controller != null:
		if ai_controller.PlayerDetected:
			shoot_abi.SetTargetActor(CurrentTargetActor)
			shoot_abi.TryActivate()
