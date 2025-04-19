class_name Field
extends Node

var __class: String = ""


func _init(_class) -> void:
	__class = _class


func __newTeam(_name: String) -> Team:
	var team: Team = Team.new(_name)
	
	return team


func addTeam(_name: String) -> void:
	var team: Team = __newTeam(_name)
	
	$Teams.add_child(team)


func focusTeam(idx: int) -> void:
	pass
