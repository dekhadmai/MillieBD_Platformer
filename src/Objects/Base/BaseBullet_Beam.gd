class_name BaseBullet_Beam
extends BaseBullet

var bodyState:Physics2DDirectBodyState
onready var area2d_damage
onready var bullet_sprite = $BulletSprite

func OnHitSurface(body):
	Activate_Beam(body)
#	bullet_spawner_component.Init(Instigator, gameplay_effect_template)
#	bullet_spawner_component.Activate()

func Activate_Beam(body):
	if area2d_damage == null:
		area2d_damage = get_node("Area2D_Damage_Telegraph")
		area2d_damage.connect("OnHurtDetection", self, "OnBulletHit")
		area2d_damage.connect("OnEndAreaLinger", self, "kill_actor")
	
	var collNorm:Vector2 = bodyState.get_contact_local_normal(0)
	var collPos:Vector2 = bodyState.get_contact_local_position(0)
	
	bullet_sprite.set_visible(false)
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
	
	area2d_damage.SetActive(true)

func _integrate_forces(state):
	bodyState = state
	pass

func OnBulletHit(body:Actor):	
	var effect:BaseGameplayEffect = gameplay_effect_template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	Instigator.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	pass

func kill_actor():
	queue_free()

