class_name Team
extends Node2D

static var focused: Team

var size: Vector2i =  Vector2i(4, 4)

var __rid: int = rid_allocate_id()


func _init(_name: String) -> void:
	name = _name
	
	add_to_group("team")


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2(4, 4), size * 64 - Vector2i(8, 8)), Color.GREEN, false, 6)
