extends BaseBullet

export var spacing_facing_offset = 30
export var spacing_random_offset = 0
export var spacing_delay = 0.1
export var spacing_total_beam = 7


func OnHitSurface(body):
	.OnHitSurface(body)
	
	GlobalFunctions.queue_free_children($BulletSpawnerComponent)
	FillBulletSpawnerComponent($BulletSpawnerComponent)
	bullet_spawner_component.Activate()

func FillBulletSpawnerComponent(spawner_comp):
	var beam_count = 0
	var x_offset = spacing_facing_offset
	var interval = 0.01
	while (beam_count < spacing_total_beam):
		var bullet_data:BulletSpawnerData = BulletSpawnerData.new()
		bullet_data.BulletData_LocalOffset = Vector2(10, 0)
		bullet_data.BulletData_InstigatorFacingDirectionOffset = Vector2(x_offset + rand_range(-spacing_random_offset, spacing_random_offset), 0)
		bullet_data.BulletData_Rotation = 180
		bullet_data.BulletData_Delay = interval
		spawner_comp.add_child(bullet_data)
		x_offset += spacing_facing_offset
		interval += spacing_delay
		beam_count += 1
