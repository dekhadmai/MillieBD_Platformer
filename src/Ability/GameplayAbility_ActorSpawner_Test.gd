extends "res://src/Ability/GameplayAbility_ActorSpawner.gd"

export(float) var loop_interval = 0.1
export(int) var loop_amount = 100
export(int) var amount = 100
onready var spin_timer = $SpinTimer
var start_angle = 0.0
var loop_count = 0

func SpawnActor() -> void:
	
	spin_timer.start(loop_interval)
		
	pass

func SpawnCircle() -> void:
	var angle = 0.0
	var rot
	for i in range(amount) : 
		rot = Vector2.UP.rotated(start_angle + angle)
		angle += deg2rad(360.0/amount)
		
		var bullet = Bullet.instance()
		bullet.set_as_toplevel(true)
		add_child(bullet)
		bullet.Init(AbilityOwner, GameplayeEffect_Template)
		bullet.global_position = GetSpawnPosition()
		var velocity = rot
		velocity *= bullet.BaseSpeed
		bullet.linear_velocity = velocity
		
	pass


func _on_SpinTimer_timeout():
	
	SpawnCircle()
	start_angle += deg2rad(3.0)
	
	loop_count += 1
	if loop_count > loop_amount:
		spin_timer.stop()
		loop_count = 0
	
	pass
