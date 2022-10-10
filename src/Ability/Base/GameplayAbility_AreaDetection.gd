extends BaseGameplayAbility

export(String, FILE) var ActorToSpawnPath
onready var Bullet = load(ActorToSpawnPath)

export var SpawnSocketName: String = "ShootSocket"
onready var SocketNode: Position2D

export var Area2D_Damage_NodeName = "Area2D_Damage"
var hurt_detection: Area2D


export var AreaLingerDuration: float = 1.0
export var AreaEffectInterval: float = 0.0



func _ready():
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
func _physics_process(delta):
	update_physics(delta)
	
func update_physics(delta):
	hurt_detection.set_scale(Vector2(AbilityOwner.FacingDirection, 1))

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
	if hurt_detection == null:
		hurt_detection = get_node(Area2D_Damage_NodeName)
		hurt_detection.connect("OnHurtDetection", self, "OnHurtDetectionHit")
		hurt_detection.connect("OnEndAreaLinger", self, "_on_Area2D_Damage_OnEndAreaLinger")
	

func Activate():
	.Activate()

	StartAreaDetection()

	pass
	
func EndAbility():
	.EndAbility()
	
func OnHurtDetectionHit(body:Actor) :
	var effect:BaseGameplayEffect = GameplayeEffect_Template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	AbilityOwner.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	

func StartAreaDetection():
	hurt_detection.SetActive(true)
	pass

func _on_Area2D_Damage_OnEndAreaLinger():
	EndAbility()
