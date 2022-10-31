class_name BaseBullet
extends RigidBody2D

export var bDebug = false
export(float) var BaseSpeed: float = 300.0
export var bRotationMatchVelocity = true

export(float) var DeathLingerDuration = 0.0

var bodyState:Physics2DDirectBodyState

var bOverrideRotation = false
var OverrideRotationAngle = 0.0

var bOverridePosition = false
var OverridePosition = Vector2.ZERO

onready var animation_player = $AnimationPlayer
var death_linger_timer
var gameplay_effect_template
var movement_component
var sprite_node

var Instigator:Actor
var OwningAbility

var bullet_spawner_component: BulletSpawnerComponent

func get_class():
	return "BaseBullet"
	
func GetTeam():
	return Instigator.GetTeam()
	
func GetInstigator() -> Actor:
	return Instigator
	
func GetBulletSprite() : 
	if sprite_node == null:
		sprite_node = find_node("Sprite")
	
	return sprite_node

func GetMovementComponent():
	if movement_component == null :
		movement_component = get_node("MovementComponent")
	
	return movement_component

func SetHomeTargetActor(target):
	GetMovementComponent().SetHomeTargetActor(target)
	
func SetHomeTargetLocation(location):
	GetMovementComponent().SetHomeTargetLocation(location)

func _ready():
	if death_linger_timer == null :
		death_linger_timer = find_node("DeathLingerTimer")

func Init(instigator:Actor, owning_ability, gameplayeffect_template:BaseGameplayEffect):
	Instigator = instigator
	OwningAbility = owning_ability
	gameplay_effect_template = gameplayeffect_template
	
	bullet_spawner_component = find_node("BulletSpawnerComponent")
	if bullet_spawner_component != null:
		bullet_spawner_component.Init(Instigator, OwningAbility, gameplay_effect_template)
		
	GetMovementComponent().SetSpeed(BaseSpeed, BaseSpeed)
	GetMovementComponent().Init()

func _physics_process(delta):
	if bRotationMatchVelocity and get_linear_velocity().length() > 0 : 
		set_global_rotation(get_linear_velocity().angle())
		
	if bOverrideRotation:
		set_global_rotation(OverrideRotationAngle)
		
	if bOverridePosition:
		set_global_position(OverridePosition)

func _integrate_forces(state):
	bodyState = state
	pass
	
func destroy():
	#animation_player.play("destroy")
	if DeathLingerDuration > 0 :
		death_linger_timer.start(DeathLingerDuration)
		
		var collNorm:Vector2 = bodyState.get_contact_local_normal(0)
		var collPos:Vector2 = bodyState.get_contact_local_position(0)
		
		GetBulletSprite().set_visible(false)
		
		if bDebug :
			GetBulletSprite().set_visible(true)
			
		bRotationMatchVelocity = false
		
		bOverrideRotation = true
		OverrideRotationAngle = collNorm.angle()
		
		bOverridePosition = true
		OverridePosition = collPos
		
		#set_continuous_collision_detection_mode(RigidBody2D.CCD_MODE_DISABLED)
		set_collision_layer(0)
		set_collision_mask(0)
		set_angular_velocity(0.0)
		set_linear_velocity(Vector2.ZERO)
	else:
		queue_free()

func _on_DeathLingerTimer_timeout():
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
	destroy()
	pass


func _on_Area2D_Damage_area_entered(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible > 0:
			if body.GetTeam() != GetTeam():
				#print(str(body) + "=" + str(body.GetTeam()) + ", " + str(Instigator) + "=" + str(GetTeam()))
				OnBulletHit(body)
	pass # Replace with function body.

