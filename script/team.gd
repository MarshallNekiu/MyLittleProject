class_name Team
extends Node

var __name: String = ""


func _init(_name) -> void:
	__name = _name


func __newUnit(_class) -> Unit:
	var unit = Unit.new(_class)
	
	return unit


func addUnit(_class: String) -> void:
	var unit: Unit = __newUnit(_class)
	
	$Units.get_node(_class).append(unit)


func focusUnit(idx) -> void:
	pass


func getName() -> String: return __name
