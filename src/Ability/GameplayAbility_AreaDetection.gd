extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var CustomAnimName: String = "_weapon"
export var CustomAnimDuration: float = 0.3 

export var LingeringAnimName: String = "_active_weapon"
export var LingeringAnimDuration: float = 1.0

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

onready var hurt_detection: Area2D = $HurtDetection
onready var area_linger_timer: Timer = $AreaLingerTimer

var affected_actors = []

func _ready():
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
	if hurt_detection == null:
		hurt_detection = get_node("HurtDetection")
	

func Activate():
	.Activate()

	StartAreaDetection()

	pass
	
func EndAbility():
	.EndAbility()
	hurt_detection.set_monitoring(false)
	hurt_detection.set_monitorable(false)
	hurt_detection.set_visible(false)
	
func OnHutDetectionHit(body:Actor) :
	var effect:BaseGameplayEffect = GameplayeEffect_Template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	AbilityOwner.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	

func StartAreaDetection():
	hurt_detection.set_global_position(SocketNode.global_position)
	hurt_detection.set_monitoring(true)
	hurt_detection.set_monitorable(true)
	hurt_detection.set_visible(true)
	area_linger_timer.start()
	pass


func _on_AreaLingerTimer_timeout():
	EndAbility()


func _on_HurtDetection_body_entered(body):
	if body != AbilityOwner : 
		if body.get_class() == "Actor":
				if !body.GetAbilitySystemComponent().CurrentCharStats.bInvincible:
					if body.GetTeam() != AbilityOwner.GetTeam():
						OnHutDetectionHit(body)
	pass # Replace with function body.
