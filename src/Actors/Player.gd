class_name Player
extends Actor


# warning-ignore:unused_signal
signal collect_coin()

const OriginalScale = 0.2
const FLOOR_DETECT_DISTANCE = 20.0
const Min_Zoom = 0.7
const Max_Zoom = 3.0

export(String) var action_suffix = ""

onready var autoload_transientdata = $"/root/AutoLoadTransientData"
onready var autoload_mapdata = $"/root/AutoLoadMapData"
onready var autoload_globalresource = $"/root/AutoloadGlobalResource"

onready var levelup_effect_atk = $LevelUpEffect_Atk
onready var levelup_effect_maxhp = $LevelUpEffect_MaxHP
onready var levelup_effect_invincible = $LevelUpEffect_Invincible

# Cheat
onready var cheat_exp = $CheatBuff/CheatExp
onready var cheat_atk = $CheatBuff/CheatAtk
onready var cheat_damage = $CheatBuff/CheatTakeDamage
onready var cheat_heal = $CheatBuff/CheatHeal
onready var cheat_invincible = $CheatBuff/CheatInvincible

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayerState
onready var shoot_timer = $ShootAnimation
onready var sprite = $Sprite
onready var sound_jump = $Jump
onready var sound_level_up = $LevelUp
onready var player_collision:CollisionShape2D = $PlayerCollision

onready var camera: Camera2D = $Camera

onready var jump_button_timer: Timer = $JumpButtonTimer
onready var float_timer: Timer = $JumpButtonTimer/FloatTimer
onready var hold_to_shoot_timer: Timer = $HoldToShootTimer
var jump_direction: float = 0
var jump_count = 0
export var jump_max_count = 2;

var float_time_remaining = 0
var float_time_max = 2.0

onready var dash_abi = $AbilitySystemComponent/Ability_Dash

onready var parallax:ParallaxBackground = $ParallaxBackground_Enna
var parallax_offset = Vector2.ZERO

onready var graze_system = $AbilitySystemComponent/GrazeSystem
onready var take_damage_vfx = $Vfx/TakeDamageVfx
onready var take_damage_sfx = $Vfx/TakeDamageSfx
onready var take_damage_vfx_timer = $Vfx/TakeDamageVfxTimer

var hp_orb = "res://src/Level/InteractableObject/ItemPickup/Pickup_Hp.tscn"
var hp_max_orb = "res://src/Level/InteractableObject/ItemPickup/Pickup_Hp_Max.tscn"
var exp_orb = "res://src/Level/InteractableObject/ItemPickup/Pickup_Exp.tscn"
var random_roomdrop = "res://src/Level/InteractableObject/ItemPickup/RandomPickup_Spawn.tscn"

var bHoldJumpToFloat = false
var HoldJumpToFloatDuration = 0.2

#####
## Ability stuff
#####

var weapon_abi
var WeaponAbilityArray = []
var WeaponAbilityTemplateNameArray = []
var WeaponAbilityIndex = -1
var WeaponAbilitySlotMax = 2

func AddWeaponAbility(dict_key: String):
	var abi_template = load(autoload_globalresource.PlayerWeaponAbilityTemplates[dict_key])
	if abi_template :
		var abi_instance = abi_template.instance()
		if is_instance_valid(abi_instance) : 
			if WeaponAbilityArray.size() < WeaponAbilitySlotMax : 
				# add new
				WeaponAbilityArray.push_back(abi_instance)
				WeaponAbilityTemplateNameArray.push_back(dict_key)
				WeaponAbilityIndex = WeaponAbilityArray.size()-1
			else : 
				# replace
				var drop = GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), "res://src/Level/InteractableObject/ItemPickup/RandomPickup_Spawn.tscn", 30)
				drop.InteractableType = 1 # weapon
				drop.ResourceTemplateKey = WeaponAbilityTemplateNameArray[WeaponAbilityIndex]
				drop.Init()
				
				WeaponAbilityArray[WeaponAbilityIndex].queue_free()
				WeaponAbilityArray[WeaponAbilityIndex] = abi_instance
				WeaponAbilityTemplateNameArray[WeaponAbilityIndex] = dict_key
			
			weapon_abi = WeaponAbilityArray[WeaponAbilityIndex]
			GetAbilitySystemComponent().add_child(abi_instance)
	pass
	
func SwapWeapon():
	WeaponAbilityIndex = (WeaponAbilityIndex + 1) % WeaponAbilityArray.size()
	weapon_abi = WeaponAbilityArray[WeaponAbilityIndex]
	

var special_abi
var SpecialAbilityArray = []
var SpecialAbilityTemplateNameArray = []
var SpecialAbilityIndex = -1
var SpecialAbilitySlotMax = 3

func AddSpecialAbility(dict_key: String):
	var abi_template = load(autoload_globalresource.PlayerSpecialAbilityTemplates[dict_key])
	if abi_template :
		var abi_instance = abi_template.instance()
		if is_instance_valid(abi_instance) : 
			if SpecialAbilityArray.size() < SpecialAbilitySlotMax : 
				# add new
				SpecialAbilityArray.push_back(abi_instance)
				SpecialAbilityTemplateNameArray.push_back(dict_key)
				SpecialAbilityIndex = SpecialAbilityArray.size()-1
			else : 
				# replace
				var drop = GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), "res://src/Level/InteractableObject/ItemPickup/RandomPickup_Spawn.tscn", 30)
				drop.InteractableType = 2 # SpecialAbility
				drop.ResourceTemplateKey = SpecialAbilityTemplateNameArray[SpecialAbilityIndex]
				drop.Init()
				
				SpecialAbilityArray[SpecialAbilityIndex].queue_free()
				SpecialAbilityArray[SpecialAbilityIndex] = abi_instance
				SpecialAbilityTemplateNameArray[SpecialAbilityIndex] = dict_key
			
			special_abi = SpecialAbilityArray[SpecialAbilityIndex]
			GetAbilitySystemComponent().add_child(abi_instance)
	pass

func SwapAbility():
	SpecialAbilityIndex = (SpecialAbilityIndex + 1) % SpecialAbilityArray.size()
	special_abi = SpecialAbilityArray[SpecialAbilityIndex]
	
func UseAbilityByIndex(idx):
	if idx < SpecialAbilityArray.size() : 
		SpecialAbilityIndex = idx
		special_abi = SpecialAbilityArray[SpecialAbilityIndex]
		if is_instance_valid(special_abi) :
			special_abi.TryActivate()
	
	
##### 

func _ready():
	# Static types are necessary here to avoid warnings.
	camera = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
		yield(get_tree(), "idle_frame")
		camera.make_current()
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport2"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport
		yield(get_tree(), "idle_frame")
		camera.make_current()
		
	autoload_transientdata.player = self
	
	sprite.scale.x = OriginalScale
	sprite.scale.y = OriginalScale
	
	if autoload_transientdata.PlayerSaveData.WeaponAbilityTemplateNameArray.size() > 0 : 
		for name in autoload_transientdata.PlayerSaveData.WeaponAbilityTemplateNameArray : 
			AddWeaponAbility(name)
	else : 
		AddWeaponAbility("HandGun")
	#	AddWeaponAbility("Shotgun")
	#	AddWeaponAbility("Minigun")
	
	
	if autoload_transientdata.PlayerSaveData.SpecialAbilityTemplateNameArray.size() > 0 : 
		for name in autoload_transientdata.PlayerSaveData.SpecialAbilityTemplateNameArray : 
			AddSpecialAbility(name)
	else : 
		AddSpecialAbility("SlowTime")
	#	AddSpecialAbility("Heal")
	#	AddSpecialAbility("Invincible")
	#	AddSpecialAbility("AttackBuff")
	#	AddSpecialAbility("Shield")
	#	AddSpecialAbility("Beam")
	#	AddSpecialAbility("Nuke")
	#	AddSpecialAbility("Homing")
		
		
	if autoload_transientdata.PlayerSaveData.Level > 0 : 
		GetAbilitySystemComponent().CurrentCharStats.CurrentLevel = autoload_transientdata.PlayerSaveData.Level
		GetAbilitySystemComponent().CurrentCharStats.MaxEXP = GetAbilitySystemComponent().CurrentCharStats.GetMaxExp()
		
	if autoload_transientdata.PlayerSaveData.CurrentEXP > 0 : 
		GetAbilitySystemComponent().CurrentCharStats.CurrentEXP = autoload_transientdata.PlayerSaveData.CurrentEXP
		
	if autoload_transientdata.PlayerSaveData.BaseHP > 0 : 
		GetAbilitySystemComponent().CurrentCharStats.BaseHP = autoload_transientdata.PlayerSaveData.BaseHP
		GetAbilitySystemComponent().CurrentCharStats.CurrentHP = GetAbilitySystemComponent().CurrentCharStats.BaseHP
		
	if autoload_transientdata.PlayerSaveData.BaseAttack > 0 : 
		GetAbilitySystemComponent().CurrentCharStats.BaseAttack = autoload_transientdata.PlayerSaveData.BaseAttack
		GetAbilitySystemComponent().CurrentCharStats.Calculate()
	
	
	save_player_transient_data()
	
	
	
	pass


func _physics_process(_delta):

	if !parallax : 
		parallax = $ParallaxBackground_Enna
	
	parallax_offset = get_global_position() #camera.get_global_position()
	parallax_offset.x = 0
	parallax_offset.y -= 28
	parallax.set_offset(parallax_offset)

	if !SettingsSave.game_data.hold_to_float : 
		if Input.is_action_just_pressed("jump"):
			if can_jump():
				do_jump()
	else : 
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() : 
				if can_jump():
					do_jump()
			else : 
				jump_button_timer.start(HoldJumpToFloatDuration)
				
		if Input.is_action_just_released("jump"):
			if !jump_button_timer.is_stopped() :
				if can_jump():
					do_jump()
				jump_button_timer.stop()
				float_timer.stop()
			else : 
				do_unfloat()
				float_timer.stop()
			
#	if Input.is_action_just_pressed("dash"):
#		if can_float():
#			jump_button_timer.start()
#		else : 
#			dash_abi.TryActivate()
#
#	if Input.is_action_just_released("dash"):
#		if !jump_button_timer.is_stopped() :
#			dash_abi.TryActivate()
#			jump_button_timer.stop()
#		do_unfloat()
#		float_timer.stop()
		
	if Input.is_action_just_pressed("float"):
		if can_float():
			do_float()
			float_timer.start(float_time_remaining)

	if Input.is_action_just_released("float"):
		do_unfloat()
		float_timer.stop()
		
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	speed.x = ability_system_component.CurrentCharStats.BaseMovespeed
	speed.y = ability_system_component.CurrentCharStats.BaseJumpSpeed
	
	if !dash_abi.IsAbilityActive() : 
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	
	if is_on_floor():
		jump_count = 0
		float_time_remaining = float_time_max
		
	if !bUseGravity :
		float_time_remaining -= _delta

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1 * OriginalScale
		else:
			sprite.scale.x = -1 * OriginalScale
			
	FacingDirection = sprite.scale.x / OriginalScale

	if Input.is_action_just_pressed("shoot"):
		var can_shoot = true
		for i in SpecialAbilityArray.size() : 
			if is_instance_valid(SpecialAbilityArray[i]) : 
				if !(!SpecialAbilityArray[i].IsAbilityActive() or (SpecialAbilityArray[i].IsAbilityActive() and SpecialAbilityArray[i].GetAllowPrimaryToActivate())) : 
					can_shoot = false
		
		if can_shoot : 
			weapon_abi.TryActivate()
			if hold_to_shoot_timer.is_stopped() :
				hold_to_shoot_timer.start()
			
	if Input.is_action_just_released("shoot"):
		hold_to_shoot_timer.stop()
	
	if Input.is_action_just_pressed("swap_weapon"):
		SwapWeapon()
		
		
	if Input.is_action_just_pressed("use_ability"):
		if is_instance_valid(special_abi) :
			special_abi.TryActivate()
		
	if Input.is_action_just_pressed("swap_ability"):
		SwapAbility()
		
	if Input.is_action_just_pressed("Skill1"):
		UseAbilityByIndex(0)
		
	if Input.is_action_just_pressed("Skill2"):
		UseAbilityByIndex(1)
		
	if Input.is_action_just_pressed("Skill3"):
		UseAbilityByIndex(2)
	
#	var abi_node = null
#	if GlobalFunctions.IsKeyModifierPressed("use_ability", "move_up"):
#		abi_node = GetAbilityNode("SpecialAbility_Up")
#		if abi_node : 
#			abi_node.TryActivate()
#	elif GlobalFunctions.IsKeyModifierPressed("use_ability", "move_down"):
#		abi_node = GetAbilityNode("SpecialAbility_Down")
#		if abi_node : 
#			abi_node.TryActivate()
#	else:
#		if Input.is_action_just_pressed("use_ability" + action_suffix):
#			abi_node = GetAbilityNode("SpecialAbility")
#			if abi_node : 
#				abi_node.TryActivate()
			
	if Input.is_action_pressed("move_down") and Input.is_action_pressed("jump"):
		set_collision_mask_bit(3, false)
	else : 
		set_collision_mask_bit(3, true)

	UpdateAnimState()
	
	if Input.is_action_just_pressed("dash" + action_suffix):
		dash_abi.TryActivate()
		
		
	CheckCheatCommands()


func get_direction() -> Vector2 :
	var result:Vector2 = Vector2.ZERO
	result.x = Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix)
	result.y = jump_direction
	jump_direction = 0
	
	return result
	
#	return Vector2(
#		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
#		-1 if do_jump() else 0
#	)

func save_player_transient_data() : 
	# save data before death
	autoload_transientdata.PlayerSaveData.WeaponAbilityTemplateNameArray.clear()
	autoload_transientdata.PlayerSaveData.WeaponAbilityTemplateNameArray.append_array(WeaponAbilityTemplateNameArray)
	
	autoload_transientdata.PlayerSaveData.SpecialAbilityTemplateNameArray.clear()
	autoload_transientdata.PlayerSaveData.SpecialAbilityTemplateNameArray.append_array(SpecialAbilityTemplateNameArray)
	
	autoload_transientdata.PlayerSaveData.BaseHP = GetAbilitySystemComponent().CurrentCharStats.BaseHP
	autoload_transientdata.PlayerSaveData.BaseAttack = GetAbilitySystemComponent().CurrentCharStats.BaseAttack
	autoload_transientdata.PlayerSaveData.Level = GetAbilitySystemComponent().CurrentCharStats.CurrentLevel
	autoload_transientdata.PlayerSaveData.CurrentEXP = GetAbilitySystemComponent().CurrentCharStats.CurrentEXP

func died():
	.died()
	save_player_transient_data()
	
	queue_free()
	
	autoload_mapdata.SpawnPlayer()
	autoload_transientdata.PlayerSaveData.DeathCount += 1
	
func level_up():
	.level_up()
	
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	var effect:BaseGameplayEffect = null
	
	if body_asc.CurrentCharStats.CurrentLevel < body_asc.CurrentCharStats.MaxLevel : 
		effect = levelup_effect_atk.duplicate() as BaseGameplayEffect
		body_asc.ApplyGameplayEffectToSelf(effect)
	
		effect = levelup_effect_maxhp.duplicate() as BaseGameplayEffect
		body_asc.ApplyGameplayEffectToSelf(effect)
	
	effect = levelup_effect_invincible.duplicate() as BaseGameplayEffect
	body_asc.ApplyGameplayEffectToSelf(effect)
	
	if !sound_level_up.is_playing() : 
		sound_level_up.play()

func can_float():
	return false if is_on_floor() or float_time_remaining <= 0.0 else true

func do_float():
	_velocity.y = 0
	bUseGravity = false
	
func do_unfloat():
	bUseGravity = true

func do_jump():
	jump_direction = -1
	
	#if !is_on_floor() : 
	jump_count += 1
	
	# Play jump sound
	sound_jump.play()

func can_jump():
	if Input.is_action_pressed("move_down"):
		return false
	
	if is_on_floor(): 
		return true
	elif !float_timer.is_stopped():
		return false
	elif jump_count < jump_max_count: 
		return true
	else:
		return false
	#return true if is_on_floor() or jump_count < jump_max_count else false

# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted and !SettingsSave.game_data.hold_to_float:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
		
	return velocity

func UpdateAnimState():
	var animation_new = ""
	
	if Input.is_action_pressed("move_up") :
		animation_new = "up_"
	elif Input.is_action_pressed("move_down") :
		animation_new = "down_"
	
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new += "run"
		else:
			animation_new += "idle"
	else:
		if _velocity.y > 0:
			animation_new += "falling"
		else:
			animation_new += "jumping"
			
	animation_player.BaseAnimState = animation_new

func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new

func try_jump():
	if Input.is_action_pressed("jump") and !is_on_floor():
		# float
		if can_float():
			do_float()
			float_timer.start()
	else:
		# jump
		if can_jump():
			do_jump()
	

func _on_JumpButtonTimer_timeout():
	if can_float() : 
		do_float()
		float_timer.start(float_time_remaining)


func _on_FloatTimer_timeout():
	do_unfloat()
	pass # Replace with function body.


func _on_HoldToShootTimer_timeout():
	if is_instance_valid(weapon_abi) : 
		if Input.is_action_pressed("shoot") : 
			var can_shoot = true
			for i in SpecialAbilityArray.size() : 
				if is_instance_valid(SpecialAbilityArray[i]) : 
					if !(!SpecialAbilityArray[i].IsAbilityActive() or (SpecialAbilityArray[i].IsAbilityActive() and SpecialAbilityArray[i].GetAllowPrimaryToActivate())) : 
						can_shoot = false
			
			if can_shoot : 
				weapon_abi.TryActivate()
		else : 
			hold_to_shoot_timer.stop()
		
func ShowGrazeVfx():
	graze_system.ShowGrazeVfx()
	
func SpawnRoomClearReward():
	var offset = Vector2(-10, 0)
	
	#GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), hp_orb, 30)
	GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition()+offset, hp_orb, 0)
	
	offset = Vector2(10, 0)
	var orb_chance = 50
	if randi() % 100 < orb_chance : 
		GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition()+offset, exp_orb, 0)
	else :
		GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition()+offset, random_roomdrop, 0)
	
	autoload_mapdata.PlaySfx("RoomClear")
	pass
	
func SpawnMiniBossRoomClearReward():
	var offset = Vector2(-10, 0)
	GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition()+offset, exp_orb, 0)
	
	offset = Vector2(10, 0)
	GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition()+offset, random_roomdrop, 0)
	
	pass

func take_damage(_value):
	if take_damage_vfx and take_damage_vfx_timer : 
		take_damage_vfx.set_frame(randi() % 4)
		take_damage_vfx.set_visible(true)
		take_damage_vfx_timer.start()
		take_damage_sfx.play()
	pass

func _on_TakeDamageVfxTimer_timeout():
	if take_damage_vfx and take_damage_vfx_timer : 
		take_damage_vfx.set_visible(false)
	

##### CHEAT COMMANDS 
func CheckCheatCommands():
	if GlobalFunctions.IsKeyModifierPressed("move_up", "CheatModifier"):
		CheatExp()
	if GlobalFunctions.IsKeyModifierPressed("move_down", "CheatModifier"):
		CheatTakeDamage()
	if GlobalFunctions.IsKeyModifierPressed("move_left", "CheatModifier"):
		CheatAddFerver()
	if GlobalFunctions.IsKeyModifierPressed("move_right", "CheatModifier"):
		CheatTeleportToBossRoom()
	if GlobalFunctions.IsKeyModifierPressed("swap_weapon", "CheatModifier"):
		CheatSpawnAllWeapons()
	if GlobalFunctions.IsKeyModifierPressed("swap_ability", "CheatModifier"):
		CheatSpawnAllSpecialAbilities()
	if GlobalFunctions.IsKeyModifierPressed("shoot", "CheatModifier"):
		CheatAtk()
	if GlobalFunctions.IsKeyModifierPressed("dash", "CheatModifier"):
		CheatInvincible()
	if GlobalFunctions.IsKeyModifierPressed("jump", "CheatModifier"):
		CheatHeal()
		
	if Input.is_action_just_released("zoom_in") and Input.is_action_pressed("CheatModifier"):
		camera.zoom.x = clamp(camera.zoom.x - 0.1, Min_Zoom, Max_Zoom)
		camera.zoom.y = clamp(camera.zoom.y - 0.1, Min_Zoom, Max_Zoom)
	
	if Input.is_action_just_released("zoom_out") and Input.is_action_pressed("CheatModifier"):	
		camera.zoom.x = clamp(camera.zoom.x + 0.1, Min_Zoom, Max_Zoom)
		camera.zoom.y = clamp(camera.zoom.y + 0.1, Min_Zoom, Max_Zoom)
	

func CheatExp():
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	var effect:BaseGameplayEffect = cheat_exp.duplicate() as BaseGameplayEffect
	body_asc.ApplyGameplayEffectToSelf(effect)
	
func CheatAtk():
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	var effect:BaseGameplayEffect = cheat_atk.duplicate() as BaseGameplayEffect
	body_asc.ApplyGameplayEffectToSelf(effect)
	
func CheatTakeDamage():
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	var effect:BaseGameplayEffect = cheat_damage.duplicate() as BaseGameplayEffect
	body_asc.ApplyGameplayEffectToSelf(effect)
	
func CheatHeal():
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	var effect:BaseGameplayEffect = cheat_heal.duplicate() as BaseGameplayEffect
	body_asc.ApplyGameplayEffectToSelf(effect)
	
func CheatInvincible():
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	var effect:BaseGameplayEffect = cheat_invincible.duplicate() as BaseGameplayEffect
	body_asc.ApplyGameplayEffectToSelf(effect)
	
func CheatAddFerver():
	var body_asc: BaseAbilitySystemComponent = GetAbilitySystemComponent()  
	body_asc.CurrentCharStats.CurrentFervor = 100
	
func CheatTeleportToBossRoom():
	autoload_mapdata.TeleportPlayer(self)
	
func CheatSpawnAllWeapons():
	var keys = autoload_globalresource.PlayerWeaponAbilityTemplates.keys()
	for key in keys : 
		var drop = GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), "res://src/Level/InteractableObject/ItemPickup/RandomPickup_Spawn.tscn", 30)
		drop.InteractableType = 1 # weapon
		drop.ResourceTemplateKey = key
		drop.Init()
		
func CheatSpawnAllSpecialAbilities():
	var keys = autoload_globalresource.PlayerSpecialAbilityTemplates.keys()
	for key in keys : 
		var drop = GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), "res://src/Level/InteractableObject/ItemPickup/RandomPickup_Spawn.tscn", 60)
		drop.InteractableType = 2 # SpecialAbility
		drop.ResourceTemplateKey = key
		drop.Init()
##### END OF CHEAT COMMANDS 


func _on_CheckRoomClearSpeedBuff_timeout():
	var current_room = autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y]
	if current_room.bIsAlreadyCleared and !(current_room.RoomType == "C" or current_room.RoomType == "B") : 
		GetAbilitySystemComponent().CurrentCharStats.BaseMovespeed = 300
	else :
		GetAbilitySystemComponent().CurrentCharStats.BaseMovespeed = 180


func DialogDeath_GetBuff(): 
	
	if GetAbilitySystemComponent().CurrentCharStats.CurrentLevel < GetAbilitySystemComponent().CurrentCharStats.MaxLevel : 
		var max_exp = GetAbilitySystemComponent().CurrentCharStats.GetMaxExp()
		var num_drop = ceil(max_exp / 2.0 / 100.0)
		
		for n in num_drop : 
			GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), exp_orb, 30)
	else : 
		GlobalFunctions.SpawnDropFromLocation(autoload_mapdata.LevelRoomMap[autoload_mapdata.CurrentPlayerRoom.x][autoload_mapdata.CurrentPlayerRoom.y].RoomInstance, GetTargetingPosition(), hp_max_orb, 30)
	pass
