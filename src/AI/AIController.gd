class_name AIController
extends Node2D

export var bDebug = false
var end_debug_position:Vector2

onready var autoload_transient = $"/root/AutoLoadTransientData"

var kinematic_body: Actor
var PlayerDetected:= false
onready var detection_range = $DetectionRange

export var bCheckLineOfSight = true
export var bUseFollowActor = true
export var bUseFollowPosition = false

export var bUseAbilityTriggerInterval = true
export var AbilityTriggerIntervalSeconds = 2.0
export var AbilityNodeName = ""
onready var AbilityTriggerIntervalTimer:Timer = $AbilityTriggerInterval
var CurrentAbilityTarget

var FollowActorTarget: Actor = null
var FollowPosition: Vector2 = Vector2.ZERO
var move_direction: Vector2

var starting_position: Vector2

onready var line_of_sight: RayCast2D = $RayCast_LineOfSight


# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = get_global_position()
	line_of_sight.set_enabled(bCheckLineOfSight)
	pass # Replace with function body.
	

func _draw():
	if bDebug:
		draw_line(Vector2(0,0), end_debug_position - get_global_position(), Color(0,1,0,1))
		draw_circle(end_debug_position - get_global_position(), 5, Color(0,1,0,1))

func GetAbilityNode(ability_node_name:String) :
	if ability_node_name != "" :
		return get_parent().GetAbilitySystemComponent().get_node(ability_node_name)
	return null
	
func _on_AbilityTriggerInterval_timeout():
	var ability_node = GetAbilityNode(AbilityNodeName)
	
	if PlayerDetected and ability_node != null:
		if is_instance_valid(CurrentAbilityTarget) : 
			if bCheckLineOfSight : 
				line_of_sight.set_cast_to( to_local(CurrentAbilityTarget.GetTargetingPosition()) )
				line_of_sight.force_raycast_update()
				if line_of_sight.is_colliding() :
					return
					
			ability_node.SetTargetActor(CurrentAbilityTarget)
		ability_node.TryActivate()

func init(kinematic: Actor):
	kinematic_body = kinematic
	if bUseAbilityTriggerInterval : 
		AbilityTriggerIntervalTimer.start(AbilityTriggerIntervalSeconds)
	
	CurrentAbilityTarget = autoload_transient.player
	
func _on_DetectionRange_body_entered(body):
	if body.GetTeam() != kinematic_body.GetTeam():
		PlayerDetected = true

func _on_DetectionRange_body_exited(body):
	if body.GetTeam() != kinematic_body.GetTeam():
		PlayerDetected = false

func update_physics(delta):
	if is_instance_valid(CurrentAbilityTarget):
		CurrentAbilityTarget = autoload_transient.player
		SetFollowActor(autoload_transient.player)
		
		
	if get_parent().bDontMoveStack <= 0 :
		kinematic_body._velocity.y = kinematic_body.move_and_slide(kinematic_body._velocity, kinematic_body.FLOOR_NORMAL).y
	
	pass
	
func MoveTo(normalized_direction: Vector2) -> bool :
	var result:= false
	
	move_direction = normalized_direction
	kinematic_body._velocity = normalized_direction * kinematic_body.GetAbilitySystemComponent().CurrentCharStats.CurrentMovespeed
	result = true
		
	return result
	
func SetFollowActor(target_actor: Actor):
	FollowActorTarget = target_actor
	
func FollowActor() -> bool :
	if bUseFollowActor:
		if bDebug:
			#if end_debug_position != FollowActorTarget.global_position :
			end_debug_position = FollowActorTarget.global_position
			update()
		return MoveTo(kinematic_body.global_position.direction_to(FollowActorTarget.global_position))
	return false
	
func SetFollowPosition(target_position: Vector2):
	FollowPosition = target_position
	
func FollowPosition() -> bool :
	if bUseFollowPosition:
		if bDebug:
			#if end_debug_position != FollowPosition :
			end_debug_position = FollowPosition
			update()
		return MoveTo(kinematic_body.global_position.direction_to(FollowPosition))
	return false
		
	
func StopMove() -> bool : 
	kinematic_body._velocity = Vector2.ZERO
	return true
	
