class_name Unit
extends Node

var size: Vector2:
	set(x): __rectNode.size = x
	get: return __rectNode.size

var __class: String = ""

var __rectNode: ReferenceRect = ReferenceRect.new()


func _init(_class: String) -> void:
	__class = _class
	
	__rectNode.border_color = Color.YELLOW
	__rectNode.border_width = 1.0
	__rectNode.editor_only = false
	__rectNode.size = Vector2(64, 64)
	__rectNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(__rectNode)


func getClass() -> String: return __class
