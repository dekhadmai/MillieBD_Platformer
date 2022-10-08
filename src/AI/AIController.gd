class_name AIController
extends Node2D

onready var autoload_transient = $"/root/AutoLoadTransientData"

var kinematic_body: Actor
var PlayerDetected:= false
onready var detection_range = $DetectionRange

export var bUseAbilityTriggerInterval = true
export var AbilityTriggerIntervalSeconds = 2.0
export var AbilityNodeName = ""
onready var AbilityTriggerIntervalTimer:Timer = $AbilityTriggerInterval
var CurrentAbilityTarget

var FollowActorTarget: Actor = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func GetAbilityNode(ability_node_name:String) :
	if ability_node_name != "" :
		return get_parent().GetAbilitySystemComponent().get_node(ability_node_name)
	return null
	
func _on_AbilityTriggerInterval_timeout():
	var ability_node = GetAbilityNode(AbilityNodeName)
	
	if PlayerDetected and ability_node != null:
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
		
	kinematic_body._velocity.y = kinematic_body.move_and_slide(kinematic_body._velocity, kinematic_body.FLOOR_NORMAL).y
	pass
	
func MoveTo(target_position: Vector2) -> bool :
	var result:= false
	
	if target_position:
		kinematic_body._velocity = target_position * kinematic_body.speed.x
		result = true
		
	return result
	
func FollowActor(target_actor: Actor) -> bool :
	FollowActorTarget = target_actor
	return MoveTo(kinematic_body.global_position.direction_to(FollowActorTarget.global_position))
	
func StopMove() -> bool : 
	kinematic_body._velocity = Vector2.ZERO
	return true
	
