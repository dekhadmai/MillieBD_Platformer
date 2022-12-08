extends BaseBullet

var bullet_spawner_comp_array = []
var bullet_spawner_component1 = null
var bullet_spawner_component2 = null

var top_left
var bottom_right
var bullet_spacing = 25
var bullet_spawn_delay_range = 0.2

var AbilityLevel1_bullet_spacing = 90
var AbilityLevel1_bullet_spawn_delay_range = 0.5

var AbilityLevel2_bullet_spacing = 75
var AbilityLevel2_bullet_spawn_delay_range = 0.2

	

func Init(instigator:Actor, owning_ability, gameplayeffect_template:BaseGameplayEffect):
	.Init(instigator, owning_ability, gameplayeffect_template)
	top_left = Instigator.get_parent().find_node("Room_TopLeft").get_global_position()
	bottom_right = Instigator.get_parent().find_node("Room_BottomRight").get_global_position()
	
	if bullet_spawner_component1 == null :
		bullet_spawner_component1 = get_node("BulletSpawnerComponent")
		
	if bullet_spawner_component2 == null :
		bullet_spawner_component2 = get_node("BulletSpawnerComponent2")
		
	
#	bullet_spawner_component1.bUseOverrideGlobalPosition = true
#	bullet_spawner_component1.OverrideGlobalPosition = top_left
	
	bullet_spawner_component2.bUseOverrideGlobalPosition = true
	bullet_spawner_component2.OverrideGlobalPosition = top_left
		
	bullet_spawner_component1.Init(Instigator, OwningAbility, gameplay_effect_template)
	bullet_spawner_component2.Init(Instigator, OwningAbility, gameplay_effect_template)
	
	var _error = bullet_spawner_component1.connect("OnSpawnBullet", self, "OnSpawnBullet")
	_error = bullet_spawner_component2.connect("OnSpawnBullet", self, "OnSpawnBullet")
	
	bullet_spawner_comp_array.append(bullet_spawner_component1)
	bullet_spawner_comp_array.append(bullet_spawner_component2)

func OnHitSurface(body):
	.OnHitSurface(body)
	
	DoSpawnerComponent(0)
	


func DoSpawnerComponent(i):
	GlobalFunctions.queue_free_children(bullet_spawner_comp_array[i])
	FillBulletSpawnerComponent(bullet_spawner_comp_array[i])
	bullet_spawner_comp_array[i].SetHomeTargetActor(GetMovementComponent().HomeTargetActor)
	bullet_spawner_comp_array[i].Activate()

func FillBulletSpawnerComponent(spawner_comp):
	var width = bottom_right.x - top_left.x
	var height = bottom_right.y - top_left.y
	var max_linger_time = 0.0
	
	if OwningAbility.AbilityLevel == 0 :
		var beam_count = 0
		var x_offset = 0
		var right_interval = 0.01
		while (x_offset <= bottom_right.x - global_position.x and beam_count < 5):
			var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
			bullet_data.BulletData_LocalOffset = Vector2(10, x_offset)
			bullet_data.BulletData_Rotation = 180
			bullet_data.BulletData_Delay = right_interval
			spawner_comp.add_child(bullet_data)
			x_offset += bullet_spacing
			right_interval += bullet_spawn_delay_range
			beam_count += 1
			
		beam_count = 0
		x_offset = 0
		var left_interval = 0.01
		while (x_offset >= top_left.x - global_position.x and beam_count < 4):
			var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
			bullet_data.BulletData_LocalOffset = Vector2(10, x_offset)
			bullet_data.BulletData_Rotation = 180
			bullet_data.BulletData_Delay = left_interval
			spawner_comp.add_child(bullet_data)
			x_offset -= bullet_spacing
			left_interval += bullet_spawn_delay_range
			beam_count += 1
			
		max_linger_time = max(right_interval+0.1, left_interval+0.1)
		
	elif OwningAbility.AbilityLevel == 1 or OwningAbility.AbilityLevel == 2 :
		if OwningAbility.AbilityLevel == 1 :
			bullet_spacing = AbilityLevel1_bullet_spacing
			bullet_spawn_delay_range = AbilityLevel1_bullet_spawn_delay_range
		else :
			bullet_spacing = AbilityLevel2_bullet_spacing
			bullet_spawn_delay_range = AbilityLevel2_bullet_spawn_delay_range
		
		var x_offset = 0
		var right_interval = 0.01
		while (x_offset <= bottom_right.x - global_position.x):
			var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
			bullet_data.BulletData_LocalOffset = Vector2(10, x_offset)
			bullet_data.BulletData_Rotation = 180
			bullet_data.BulletData_Delay = right_interval
			spawner_comp.add_child(bullet_data)
			x_offset += bullet_spacing
			right_interval += bullet_spawn_delay_range
			
		x_offset = 0
		var left_interval = 0.01
		while (x_offset >= top_left.x - global_position.x):
			var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
			bullet_data.BulletData_LocalOffset = Vector2(10, x_offset)
			bullet_data.BulletData_Rotation = 180
			bullet_data.BulletData_Delay = left_interval
			spawner_comp.add_child(bullet_data)
			x_offset -= bullet_spacing
			left_interval += bullet_spawn_delay_range
			
		max_linger_time = max(right_interval+0.1, left_interval+0.1)
	
#	if spawner_comp == bullet_spawner_component1:
#		#for i in 3:
#
#
#	if spawner_comp == bullet_spawner_component2:
#		for i in 3:
#			var y_offset = 0
#			while (y_offset <= height):
#				var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
#				if randf() < 0.5 :
#					bullet_data.BulletData_LocalOffset = Vector2(0, y_offset)
#					bullet_data.BulletData_Rotation = 0
#				else:
#					bullet_data.BulletData_LocalOffset = Vector2(width, y_offset)
#					bullet_data.BulletData_Rotation = 180
#				bullet_data.BulletData_Delay = i*bullet_spawn_delay_range + rand_range(0.01, bullet_spawn_delay_range)
#				spawner_comp.add_child(bullet_data)
#				y_offset += bullet_spacing
				
	death_linger_timer.start(max_linger_time)
