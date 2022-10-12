extends BaseBullet

var bRotateToTarget = true

export var BounceMaxCount = 1
var BounceCount = 0
var HomeTarget
var TargetOffset:Vector2
var TargetPosition:Vector2

var RandomRadius = 50
var InnerRadius = 150

var top_left
var bottom_right

func _draw():
	if bDebug and BounceCount <= BounceMaxCount:
		draw_line(Vector2(0,0), to_local(TargetPosition), Color(0,1,0,1))
		draw_circle(to_local(TargetPosition), 5, Color(0,1,0,1))

func _physics_process(delta):
	if bDebug:
		update()
		
	if bRotateToTarget :
		if is_instance_valid(HomeTarget):
			set_global_rotation(TargetPosition.angle_to_point(get_global_position()))
			
	if (TargetPosition - get_global_position()).length() < 5:
		GenerateTargetPosition()
	
	pass

func Init(instigator:Actor, owning_ability, gameplayeffect_template:BaseGameplayEffect):
	.Init(instigator, owning_ability, gameplayeffect_template)
	top_left = instigator.top_left
	bottom_right = instigator.bottom_right

func SetHomeTargetActor(target):
	.SetHomeTargetActor(target)
	HomeTarget = target
	GenerateTargetPosition()


func GenerateTargetPosition():
	if BounceCount <= BounceMaxCount:
		var result:Vector2
		var random_position:Vector2 = Vector2(rand_range(-RandomRadius, RandomRadius), rand_range(-RandomRadius, RandomRadius))
		var inner_vector = random_position.normalized() * InnerRadius
		if is_instance_valid(HomeTarget):
			TargetPosition = HomeTarget.GetTargetingPosition() + random_position + inner_vector
			TargetPosition.x = clamp(TargetPosition.x, top_left.x, bottom_right.x)
			TargetPosition.y = clamp(TargetPosition.y, top_left.y, bottom_right.y)
			set_global_rotation(TargetPosition.angle_to_point(get_global_position()))
			GetMovementComponent().Init()
			
	BounceCount += 1
