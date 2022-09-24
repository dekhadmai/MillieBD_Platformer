class_name BaseBullet
extends RigidBody2D

export(float) var BaseSpeed: float = 300.0
export var bRotationMatchVelocity = true

var bOverrideRotation = false
var OverrideRotationAngle = 0.0

var bOverridePosition = false
var OverridePosition = Vector2.ZERO

onready var animation_player = $AnimationPlayer
var gameplay_effect_template
var movement_component

var Instigator:Actor

var bullet_spawner_component: BulletSpawnerComponent

func get_class():
	return "BaseBullet"
	
func GetTeam():
	return Instigator.GetTeam()
	
func GetInstigator() -> Actor:
	return Instigator

func GetMovementComponent():
	if movement_component == null :
		movement_component = get_node("MovementComponent")
	
	return movement_component

func SetHomeTargetActor(target):
	GetMovementComponent().SetHomeTargetActor(target)
	
func SetHomeTargetLocation(location):
	GetMovementComponent().SetHomeTargetLocation(location)

func Init(instigator:Actor, gameplayeffect_template:BaseGameplayEffect):
	bullet_spawner_component = get_node("BulletSpawnerComponent")
	
	Instigator = instigator
	gameplay_effect_template = gameplayeffect_template
		
	GetMovementComponent().SetSpeed(BaseSpeed, BaseSpeed)
	GetMovementComponent().Init()

func _physics_process(delta):
	if bRotationMatchVelocity and get_linear_velocity().length() > 0 : 
		set_global_rotation(get_linear_velocity().angle())
		
	if bOverrideRotation:
		set_global_rotation(OverrideRotationAngle)
		
	if bOverridePosition:
		set_global_position(OverridePosition)

func destroy():
	#animation_player.play("destroy")
	queue_free()


func _on_body_entered(body):
	OnBodyEnter(body)

func OnBodyEnter(body):
	OnHitSurface(body)

func OnHitSurface(body):
	destroy()
	

func OnBulletHit(body:Actor):	
	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	
	#body.destroy()
	queue_free()
	pass


func _on_Area2D_Damage_area_entered(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible:
			if body.GetTeam() != GetTeam():
				#print(str(body) + "=" + str(body.GetTeam()) + ", " + str(Instigator) + "=" + str(GetTeam()))
				OnBulletHit(body)
	pass # Replace with function body.
