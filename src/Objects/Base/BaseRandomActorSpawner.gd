extends Node2D

onready var editor_hint = $EditorSpriteHint

export var bUseTestEnemy = false
export(String, FILE) var TestEnemy

export(Array, String, FILE, "*.tscn") var RandomActorTemplatePool
var ValidActorToSpawn = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint() :
		editor_hint.set_visible(true)
	else:
		editor_hint.set_visible(false)
		
	
	for i in RandomActorTemplatePool.size() :
		if RandomActorTemplatePool[i] != null :
			ValidActorToSpawn.append(RandomActorTemplatePool[i])
			
	pass # Replace with function body.

func Activate():
	SpawnActor()

func GetActorToSpawn() -> Actor:
	if !bUseTestEnemy:
		return ValidActorToSpawn[randi() % ValidActorToSpawn.size()]
	else:
		return TestEnemy

func SpawnActor() -> void:
	
	var actor_string = GetActorToSpawn()
	var actor = load(actor_string)
	var actor_instance = actor.instance()

	#actor.set_as_toplevel(true)
	var parent = get_parent()
	parent.add_child(actor_instance)
	
	actor_instance.global_position = GetSpawnPosition()
	pass

func GetSpawnPosition() -> Vector2:
	return self.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DelaySpawnTimer_timeout():
	Activate()
	pass # Replace with function body.
