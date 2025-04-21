class_name Team
extends Node2D

var size: Vector2:
	set(x): __rectNode.size = x
	get: return __rectNode.size

var __name: String = ""
var __units: Array[Unit]
var __focus: Unit

var __rectNode: ReferenceRect = ReferenceRect.new()
var __unitsNode: Node2D = Node2D.new()

var __rid: int = rid_allocate_id()


func _init(_name: String) -> void:
	__name = _name
	
	__rectNode.border_color = Color.GREEN
	__rectNode.border_width = 2.0
	__rectNode.editor_only = false
	__rectNode.size = Vector2(256, 192)
	__rectNode.pivot_offset = __rectNode.size * 0.5
	__rectNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var normalsNode: Node2D = Node2D.new()
	normalsNode.name = "normal"
	
	__unitsNode.add_child(normalsNode)
	add_child(__rectNode)
	add_child(__unitsNode)


func _process(delta: float) -> void:
	if is_instance_valid(__focus):
		pass # FOCUS ANIMATION
	__rectNode.scale = Vector2.ONE + ((Vector2.ONE * 2) * sin(Time.get_ticks_msec() * 0.005)) / __rectNode.size


func __newUnit(_class: String) -> Unit:
	var unit: Unit = Unit.new(_class)
	return unit


func attachUnit(_class: String) -> void:
	var unit: Unit = __newUnit(_class)
	__units.append(unit)


func addUnit(idx: int) -> void:
	var unit: Unit = __units[idx]
	__unitsNode.get_node(unit.getClass()).add_child(unit)


func focusUnit(idx: int) -> void:
	if is_instance_valid(__focus):
		pass
	__focus = __units[idx]


func getName() -> String: return __name
