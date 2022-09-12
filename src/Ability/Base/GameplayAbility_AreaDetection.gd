extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

export var Area2D_Damage_NodeName = "Area2D_Damage"
var hurt_detection: Area2D
onready var area_linger_timer: Timer = $AreaLingerTimer
onready var effect_interval_timer: Timer = $EffectIntervalTimer

export var AreaLingerDuration: float = 1.0
export var AreaEffectInterval: float = 0.0

var affected_actors = []

func _ready():
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
func _physics_process(delta):
	hurt_detection.set_scale(Vector2(AbilityOwner.FacingDirection, 1))

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
	if hurt_detection == null:
		hurt_detection = get_node(Area2D_Damage_NodeName)
		hurt_detection.connect("area_entered", self, "_on_Area2D_Damage_area_entered")
		hurt_detection.connect("area_exited", self, "_on_Area2D_Damage_area_exited")
		
	if effect_interval_timer == null:
		effect_interval_timer = get_node("EffectIntervalTimer")
	

func Activate():
	.Activate()

	affected_actors.clear()
	StartAreaDetection()

	pass
	
func EndAbility():
	.EndAbility()
	hurt_detection.SetActive(false)
	effect_interval_timer.stop()
	affected_actors.clear()
	
func OnHurtDetectionHit(body:Actor) :
	var effect:BaseGameplayEffect = GameplayeEffect_Template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	AbilityOwner.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	

func StartAreaDetection():
	hurt_detection.SetActive(true)
	area_linger_timer.start(AreaLingerDuration)
	
	if effect_interval_timer == null:
		effect_interval_timer = get_node("EffectIntervalTimer")
		
	if AreaEffectInterval > 0 :
		effect_interval_timer.start(AreaEffectInterval)
	
	pass

func _on_AreaLingerTimer_timeout():
	EndAbility()


func _on_EffectIntervalTimer_timeout():
	for i in affected_actors.size() : 
		OnHurtDetectionHit(affected_actors[i])
	pass # Replace with function body.


func _on_Area2D_Damage_area_entered(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible:
			if body.GetTeam() != AbilityOwner.GetTeam():
				OnHurtDetectionHit(body)
				affected_actors.append(body)


func _on_Area2D_Damage_area_exited(area):
	if area.get_collision_layer_bit(7) :
		var body:Actor = area.GetOwnerObject()
		if body.GetTeam() != AbilityOwner.GetTeam():
			affected_actors.erase(body)
