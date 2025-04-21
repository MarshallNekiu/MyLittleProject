class_name Unit
extends Node2D

static var focused: Unit

var __class: String = ""
var __rid: int = rid_allocate_id()


func _init(_class: String) -> void:
	__class = _class


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var localEvent: InputEventScreenTouch = make_input_local(event)
		if event.is_pressed():
			if Rect2(Vector2.ZERO, Vector2(64, 64)).has_point(localEvent.position):
				focused = self


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2(0, 0), Vector2(64, 64)), Color.YELLOW, false, 2)


func move(_vector: Vector2, _step: int) -> void:
	for i in _step:
		await create_tween().tween_property(self, "position", (position + _vector * 64) / (Vector2(64, 64)).round() * 64, 0.05).finished


func getClass() -> String: return __class
