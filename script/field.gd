class_name Field
extends Node2D

static var focused: Field

var size: Vector2i = Vector2i(5, 5)

var __season: String = ""
var __rid: int = rid_allocate_id()


func _init(_season: String) -> void:
	__season = _season
	
	add_to_group("field")


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2i(2, 2), size * 64 - Vector2i(4, 4)), Color.ORANGE, false, 8)


func get_season() -> String: return __season
