class_name BulletSpawnerData
extends Position2D


export var BulletData_LocalOffset: Vector2
export var BulletData_InstigatorFacingDirectionOffset: Vector2
export var BulletData_GlobalOffset: Vector2
export var BulletData_Rotation: float
export var BulletData_Delay: float = 0.01

signal OnSpawnBullet(bullet)

var Bullet
var bullet_spawner_data: BulletSpawnerData

var spawn_timer: Timer

func Init():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.connect("timeout", self, "OnSpawnTimerTimeout")
	spawn_timer.set_one_shot(true)
	spawn_timer.start(BulletData_Delay)
	pass
	
func OnSpawnTimerTimeout():
	SpawnBullet()

func SpawnBullet() -> void:
	bullet_spawner_data = self
	var spawner_component = get_parent()
	
	var bullet = spawner_component.Bullet.instance()
	bullet.global_position = get_global_position() + bullet_spawner_data.BulletData_LocalOffset.rotated(get_global_rotation())
	bullet.global_position += BulletData_InstigatorFacingDirectionOffset.rotated(Vector2(spawner_component.Instigator.FacingDirection, 0).angle())
	bullet.global_position += BulletData_GlobalOffset
	bullet.set_global_rotation(get_global_rotation() + deg2rad(bullet_spawner_data.BulletData_Rotation))
	bullet.Init(spawner_component.Instigator, spawner_component.gameplay_effect_template)
	if spawner_component.TargetActor != null:
		bullet.SetHomeTargetActor(spawner_component.TargetActor)

	bullet.set_as_toplevel(true)
	spawner_component.Instigator.add_child(bullet)
	
	emit_signal("OnSpawnBullet", bullet)
	pass

