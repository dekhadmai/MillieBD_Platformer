class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.

enum Enum_TeamID {None, Player, Enemy}
export(Enum_TeamID) var Team_ID
export var speed:Vector2 = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

export var bUseGravity: bool = true

var bIsDead:bool = false

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

var FacingDirection: float = 1.0

func _ready():
	GetAbilitySystemComponent().connect("died", self, "died")

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	if bUseGravity :
		_velocity.y += gravity * delta


func GetTeam():
	return 

func GetAbilitySystemComponent() -> BaseAbilitySystemComponent:
	return get_node("AbilitySystemComponent") as BaseAbilitySystemComponent
	
func died():
	bIsDead = true
