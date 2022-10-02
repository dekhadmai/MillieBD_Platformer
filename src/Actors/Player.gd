class_name Player
extends Actor


# warning-ignore:unused_signal
signal collect_coin()

const OriginalScale = 0.2
const FLOOR_DETECT_DISTANCE = 20.0
const Min_Zoom = 0.5
const Max_Zoom = 3.0

export(String) var action_suffix = ""

onready var autoload_transientdata = $"/root/AutoLoadTransientData"

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayerState
onready var shoot_timer = $ShootAnimation
onready var sprite = $Sprite
onready var sound_jump = $Jump
onready var player_collision:CollisionShape2D = $PlayerCollision

#onready var ability_system_component:BaseAbilitySystemComponent = $AbilitySystemComponent
onready var shoot_abi = $AbilitySystemComponent/ShootAbility
onready var special_abi = $AbilitySystemComponent/SpecialAbility
onready var special_abi_up = $AbilitySystemComponent/SpecialAbility_Up
onready var gameplay_ability_melee = $AbilitySystemComponent/GameplayAbility_AreaDetection_Beam
onready var dash_abi = $AbilitySystemComponent/Ability_Dash

onready var camera = $Camera

onready var jump_button_timer: Timer = $JumpButtonTimer
onready var float_timer: Timer = $JumpButtonTimer/FloatTimer
var jump_direction: float = 0
var jump_count = 0
export var jump_max_count = 1;

func _ready():
	# Static types are necessary here to avoid warnings.
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
		yield(get_tree(), "idle_frame")
		camera.make_current()
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport2"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport
		yield(get_tree(), "idle_frame")
		camera.make_current()
		
	autoload_transientdata.player = self
	
	sprite.scale.x = OriginalScale
	sprite.scale.y = OriginalScale
	
	pass

func _physics_process(_delta):

	if Input.is_action_just_pressed("jump"):
		if can_jump():
			do_jump()
			
#	if Input.is_action_just_pressed("dash"):
#		if can_float():
#			jump_button_timer.start()
#		else : 
#			dash_abi.TryActivate()
#
#	if Input.is_action_just_released("dash"):
#		if !jump_button_timer.is_stopped() :
#			dash_abi.TryActivate()
#			jump_button_timer.stop()
#		do_unfloat()
#		float_timer.stop()
		
	if Input.is_action_just_pressed("float"):
		if can_float():
			do_float()
			float_timer.start()

	if Input.is_action_just_released("float"):
		do_unfloat()
		float_timer.stop()
		
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	speed.x = ability_system_component.CurrentCharStats.BaseMovespeed
	speed.y = ability_system_component.CurrentCharStats.BaseJumpSpeed
	
	if !dash_abi.IsAbilityActive() : 
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	
	if is_on_floor():
		jump_count = 0

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1 * OriginalScale
		else:
			sprite.scale.x = -1 * OriginalScale
			
	FacingDirection = sprite.scale.x / OriginalScale

	if Input.is_action_just_pressed("shoot" + action_suffix):
		shoot_abi.TryActivate()
	
	if GlobalFunctions.IsKeyModifierPressed("use_ability", "move_up"):
		special_abi_up.TryActivate()
	elif GlobalFunctions.IsKeyModifierPressed("use_ability", "move_down"):
		gameplay_ability_melee.TryActivate()
	else:
		if Input.is_action_just_pressed("use_ability" + action_suffix):
			special_abi.TryActivate()
			
	if Input.is_action_pressed("move_down") and Input.is_action_pressed("jump"):
		set_collision_mask_bit(3, false)
	else : 
		set_collision_mask_bit(3, true)

	UpdateAnimState()
	
	if Input.is_action_just_pressed("dash" + action_suffix):
		if Input.get_action_strength("move_right") - Input.get_action_strength("move_left") != 0 : 
			dash_abi.TryActivate()
	
	if Input.is_action_just_released("zoom_in"):
		camera.zoom.x = clamp(camera.zoom.x - 0.1, Min_Zoom, Max_Zoom)
		camera.zoom.y = clamp(camera.zoom.y - 0.1, Min_Zoom, Max_Zoom)
		
	if Input.is_action_just_released("zoom_out"):
		camera.zoom.x = clamp(camera.zoom.x + 0.1, Min_Zoom, Max_Zoom)
		camera.zoom.y = clamp(camera.zoom.y + 0.1, Min_Zoom, Max_Zoom)

func get_direction() -> Vector2 :
	var result:Vector2
	result.x = Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix)
	result.y = jump_direction
	jump_direction = 0
	
	return result
	
#	return Vector2(
#		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
#		-1 if do_jump() else 0
#	)
	
func died():
	.died()
	#queue_free()

func can_float():
	return false if is_on_floor() else true

func do_float():
	_velocity.y = 10
	bUseGravity = false
	
func do_unfloat():
	bUseGravity = true

func do_jump():
	jump_direction = -1
	
	if !is_on_floor() : 
		jump_count += 1
	
	# Play jump sound
	sound_jump.play()

func can_jump():
	var result: bool = false
	if Input.is_action_pressed("move_down"):
		return false
	
	if is_on_floor(): 
		return true
	elif !float_timer.is_stopped():
		return false
	elif jump_count < jump_max_count: 
		return true
	else:
		return false
	#return true if is_on_floor() or jump_count < jump_max_count else false

# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
		
	return velocity

func UpdateAnimState():
	var animation_new = ""
	
	if Input.is_action_pressed("move_up") :
		animation_new = "up_"
	elif Input.is_action_pressed("move_down") :
		animation_new = "down_"
	
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new += "run"
		else:
			animation_new += "idle"
	else:
		if _velocity.y > 0:
			animation_new += "falling"
		else:
			animation_new += "jumping"
			
	animation_player.BaseAnimState = animation_new

func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new

func try_jump():
	if Input.is_action_pressed("jump") and !is_on_floor():
		# float
		if can_float():
			do_float()
			float_timer.start()
	else:
		# jump
		if can_jump():
			do_jump()
	

func _on_JumpButtonTimer_timeout():
	do_float()
	float_timer.start()


func _on_FloatTimer_timeout():
	do_unfloat()
	pass # Replace with function body.
