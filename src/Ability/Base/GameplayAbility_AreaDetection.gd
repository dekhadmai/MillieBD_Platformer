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
	hurt_detection.set_global_rotation(GetSpawnRotation().angle())
	
	#hurt_detection.set_scale(Vector2(AbilityOwner.FacingDirection, 1))

func Init():
	.Init()
	if SocketNode == null:
		SocketNode = AbilityOwner.find_node(SpawnSocketName)
		
	if hurt_detection == null:
		hurt_detection = find_node(Area2D_Damage_NodeName)
		if hurt_detection :
			hurt_detection.connect("OnHurtDetection", self, "OnHurtDetectionHit")
			hurt_detection.connect("OnEndAreaLinger", self, "_on_Area2D_Damage_OnEndAreaLinger")
	
	
func DoAbility():
	.DoAbility()
	StartAreaDetection()
	
func Deactivate():
	.Deactivate()
	
func EndAbility():
	.EndAbility()
	
func GetSpawnRotation() -> Vector2:
	var vec : Vector2
	
	
	vec = Vector2(AbilityOwner.FacingDirection, 0)

	if AbilityOwner is Player : 
		if Input.is_action_pressed("move_up") :
			vec.x = 0.0
			vec.y -= 1.0
		if Input.is_action_pressed("move_down") :
			vec.x = 0.0
			vec.y += 1.0
		
	return vec
	
func OnHurtDetectionHit(body:Actor) :
	var effect:BaseGameplayEffect = GameplayeEffect_Template.duplicate() as BaseGameplayEffect
	var body_asc: BaseAbilitySystemComponent = body.GetAbilitySystemComponent()
	
	AbilityOwner.GetAbilitySystemComponent().ApplyGameplayEffectToTarget(body_asc, effect)
	

func StartAreaDetection():
	if hurt_detection :
		hurt_detection.SetActive(true)
	pass

func _on_Area2D_Damage_OnEndAreaLinger():
	EndAbility()
