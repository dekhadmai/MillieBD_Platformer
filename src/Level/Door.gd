class_name Door
extends Node2D

onready var area: CollisionShape2D = $Area2D/CollisionShape2D
export var door_extent_x = 10.0
export var door_extent_y = 35.0

func _ready():
	area.shape.set_extents(Vector2(door_extent_x, door_extent_y))
