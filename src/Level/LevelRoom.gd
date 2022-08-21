class_name LevelRoom
extends Node


onready var tilemap:TileMap = $TileMap
onready var area:CollisionShape2D = $Area2D/CollisionShape2D
onready var bound:Rect2


# Called when the node enters the scene tree for the first time.
func _ready():
	#area.shape.set_extents(tilemap.get_used_rect().size)
	var r = tilemap.get_used_rect().size
	var r2 = tilemap.get_global_position()
	
	bound = Rect2(tilemap.get_global_position(), tilemap.get_used_rect().size * tilemap.get_cell_size())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
