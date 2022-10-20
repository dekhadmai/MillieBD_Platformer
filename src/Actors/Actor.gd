class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.

enum Enum_TeamID {None, Player, Enemy}
export(Enum_TeamID) var Team_ID
var speed:Vector2 = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

onready var ability_system_component
onready var TargetingSocket: Position2D = find_node("TargetingSocket")

export var bUseGravity: bool = true

var bIsDead:bool = false

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

var FacingDirection: float = 1.0
var CurrentTargetActor: Actor

func get_class():
	return "Actor"
	
func GetInstigator() -> Actor:
	return self

func _ready():
	GetAbilitySystemComponent().connect("died", self, "died")
	GetAbilitySystemComponent().connect("take_damage", self, "take_damage")

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	if bUseGravity :
		_velocity.y += gravity * delta


# helper functions

func GetTeam() -> int :
	return Team_ID

func GetAbilitySystemComponent() -> BaseAbilitySystemComponent:
	if ability_system_component:
		return ability_system_component
	else:
		ability_system_component = get_node("AbilitySystemComponent")
		return ability_system_component
	
func GetAbilityNode(node_name):
	var comp = GetAbilitySystemComponent()
	if comp :
		return comp.get_node(node_name)
	return null
	
func died():
	bIsDead = true
	
func take_damage(value):
	pass

func GetTargetingPosition() -> Vector2:
	return TargetingSocket.global_position
	
# end of helper functions
