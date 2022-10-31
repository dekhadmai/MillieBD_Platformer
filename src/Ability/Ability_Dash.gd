extends BaseGameplayAbility


onready var dash_duration_timer: Timer = $DashDuration
onready var effect_exp: BaseGameplayEffect = $Effect_ExpMultiplier
var dash_direction: float = 0.0

var player_current_stat: CharacterStats

export var dash_speed = 4.0

var original_extends:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	player_current_stat = AbilityOwner.GetAbilitySystemComponent().CurrentCharStats
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dash_direction != 0:
		AbilityOwner._velocity.x = player_current_stat.BaseMovespeed * (1 if dash_direction > 0 else -1) * dash_speed
		AbilityOwner._velocity.y = 0.0
	pass

func DoAbility():
	.DoAbility()
	do_dash()
	
	var effect:BaseGameplayEffect = effect_exp.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = AbilityOwner.GetAbilitySystemComponent()
	
	body_asc.ApplyGameplayEffectToSelf(effect)
	
	pass

func do_dash():
	PlayFullBodyAnimation("dash", 0.2)
#	original_extends = AbilityOwner.player_collision.get_shape().get_extents()
#	var shrink_extends = original_extends
#	shrink_extends.y /= 3.0
#	AbilityOwner.player_collision.get_shape().set_extents(shrink_extends)
#	AbilityOwner.player_collision.position.y = -shrink_extends.y
	dash_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player_current_stat.bInvincible += 1
	dash_duration_timer.start()
	pass

func _on_DashDuration_timeout():
	dash_direction = 0
	player_current_stat.bInvincible -= 1
#	AbilityOwner.player_collision.get_shape().set_extents(original_extends)
#	AbilityOwner.player_collision.position.y = -original_extends.y
	EndAbility()
	pass
