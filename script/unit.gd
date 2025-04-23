class_name Unit
extends Node2D

enum STATE{IDLE, MOVING}

static var focused: Unit

var size: Vector2i = Vector2i(1, 1)

var __type: String = ""
var __state: STATE = STATE.IDLE
var __rid: int = rid_allocate_id()


func _init(_type: String) -> void:
	__type = _type
	
	add_to_group("unit")


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2(8, 8), size * 64 - Vector2i(16, 16)), Color.YELLOW, false, 4)


func move(_vector: Vector2, _step: int, _t: float = 0.02) -> void:
	if not __state == STATE.IDLE:
		return
	__state = STATE.MOVING
	for i in _step:
		await create_tween().tween_property(self, "position", (position + _vector * 64) / (Vector2(64, 64)).round() * 64, _t).finished
	__state = STATE.IDLE


func get_type() -> String: return __type
