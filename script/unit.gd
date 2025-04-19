class_name Unit
extends Node

var __class: String = ""


func _init(_class: String) -> void:
	__class = _class


func getClass() -> String: return __class
