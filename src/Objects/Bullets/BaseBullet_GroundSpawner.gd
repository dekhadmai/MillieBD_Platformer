extends BaseBullet


func OnHitSurface(body):
	.OnHitSurface(body)
	
	bullet_spawner_component.Activate()
