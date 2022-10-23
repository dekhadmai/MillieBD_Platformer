extends "res://src/Ability/GameplayAbility_ActorSpawner_BulletSpawner.gd"

var bullet_spawner_comp_array = []
var bullet_spawner_component1 = null
var bullet_spawner_component2 = null

var end_ability_timer:Timer

var top_left
var bottom_right
var bullet_spacing = 30
var bullet_spawn_delay_range = 3.0

onready var invul_sprite = $InvulSprite

func _ready():
	top_left = AbilityOwner.get_parent().find_node("Room_TopLeft").get_global_position()
	bottom_right = AbilityOwner.get_parent().find_node("Room_BottomRight").get_global_position()
	
	if bullet_spawner_component1 == null :
		bullet_spawner_component1 = get_node("BulletSpawnerComponent")
		
	if bullet_spawner_component2 == null :
		bullet_spawner_component2 = get_node("BulletSpawnerComponent2")
		
	#bullet_spawner_component1.set_global_position(top_left)
	bullet_spawner_component1.bUseOverrideGlobalPosition = true
	bullet_spawner_component1.OverrideGlobalPosition = top_left
	#bullet_spawner_component2.set_global_position(top_left)
	bullet_spawner_component2.bUseOverrideGlobalPosition = true
	bullet_spawner_component2.OverrideGlobalPosition = top_left
		
	bullet_spawner_component1.Init(AbilityOwner, self, GameplayeEffect_Template)
	bullet_spawner_component2.Init(AbilityOwner, self, GameplayeEffect_Template)
	
	bullet_spawner_component1.connect("OnSpawnBullet", self, "OnSpawnBullet")
	bullet_spawner_component2.connect("OnSpawnBullet", self, "OnSpawnBullet")
	
	bullet_spawner_comp_array.append(bullet_spawner_component1)
	bullet_spawner_comp_array.append(bullet_spawner_component2)
	
	end_ability_timer = get_node("EndAbilityTimer")
	bEndAbilityAfterActivate = false

func SpawnActor() -> void:
	#AbilityLevel = 2
	
	if AbilityLevel == 2:
		DoSpawnerComponent(0)
		DoSpawnerComponent(1)
	else:
		DoSpawnerComponent(AbilityLevel)
	
#	AbilityLevel += 1
#	AbilityLevel = AbilityLevel % 3
	
	end_ability_timer.start(bullet_spawn_delay_range * 4)
	
	#.SpawnActor()

func DoSpawnerComponent(i):
	GlobalFunctions.queue_free_children(bullet_spawner_comp_array[i])
	FillBulletSpawnerComponent(bullet_spawner_comp_array[i])
	bullet_spawner_comp_array[i].SetHomeTargetActor(TargetActor)
	bullet_spawner_comp_array[i].Activate()

func FillBulletSpawnerComponent(spawner_comp):	
	var width = bottom_right.x - top_left.x
	var height = bottom_right.y - top_left.y
	
	if spawner_comp == bullet_spawner_component1:
		for i in 3:
			var x_offset = 0
			while (x_offset <= width):
				var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
				bullet_data.BulletData_LocalOffset = Vector2(x_offset, 0)
				bullet_data.BulletData_Rotation = 90
				bullet_data.BulletData_Delay = i*bullet_spawn_delay_range + rand_range(0.01, bullet_spawn_delay_range)
				spawner_comp.add_child(bullet_data)
				x_offset += bullet_spacing
				
	if spawner_comp == bullet_spawner_component2:
		for i in 3:
			var y_offset = 0
			while (y_offset <= height):
				var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
				if randf() < 0.5 :
					bullet_data.BulletData_LocalOffset = Vector2(0, y_offset)
					bullet_data.BulletData_Rotation = 0
				else:
					bullet_data.BulletData_LocalOffset = Vector2(width, y_offset)
					bullet_data.BulletData_Rotation = 180
				bullet_data.BulletData_Delay = i*bullet_spawn_delay_range + rand_range(0.01, bullet_spawn_delay_range)
				spawner_comp.add_child(bullet_data)
				y_offset += bullet_spacing

func OnSpawnBullet(bullet):
	if AbilityLevel == 2 :
		bullet.second_move_speed = 130
	
#	if bullet_spawner_component == bullet_spawner_component3 :
#		bullet.second_move_seconds = 1.5 + move_offset_sec
#		move_offset_sec += 0.2
#
#	if bullet_spawner_component == bullet_spawner_component2 :
#		bullet.second_move_speed = 300
#		bullet.GetMovementComponent().HomingStrength = 600
	pass

func _on_EndAbilityTimer_timeout():
	EndAbility()


func Activate():
	.Activate()
	
func DoAbility():
	AbilityOwner.GetAbilitySystemComponent().CurrentCharStats.bInvincible = true
	invul_sprite.set_visible(true)
	.DoAbility()
	
func Deactivate():
	AbilityOwner.GetAbilitySystemComponent().CurrentCharStats.bInvincible = false
	invul_sprite.set_visible(false)
	AbilityOwner.Stun()
	.Deactivate()
