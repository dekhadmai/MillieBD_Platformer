class_name BaseEnemy
extends Actor

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayerState
onready var ai_controller = $AIController

onready var shoot_abi = $AbilitySystemComponent/ShootAbility
onready var autoload_transient = $"/root/AutoLoadTransientData"


# Called when the node enters the scene tree for the first time.
func _ready():
	if ai_controller != null : 
		ai_controller.Init(self)

func _physics_process(_delta):

	if ai_controller != null : 
		ai_controller.Tick(_delta)
	else:
		move_and_slide(_velocity, FLOOR_NORMAL)

	# We flip the Sprite depending on which way the enemy is moving.
	if _velocity.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
		
	FacingDirection = sprite.scale.x

	UpdateAnimState()

func died():
	.died()
	destroy()

func destroy():
	queue_free()


func UpdateAnimState():
	var animation_new = ""
	animation_player.BaseAnimState = animation_new
