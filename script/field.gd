class_name Field
extends Node2D

signal focused(_field: Field)
signal teamFocused(_field: Field, _team: Team)
signal unitFocused(_field: Field, _team: Team, _unit: Unit)

var size: Vector2:
	set(x): __rectNode.size = x
	get: return __rectNode.size

var __class: String = ""
var __teams: Array[Team]
var __focus: Team

var __rectNode: ReferenceRect = ReferenceRect.new()
var __teamsNode: Node2D = Node2D.new()

var __rid: int = rid_allocate_id()


func _init(_class: String) -> void:
	__class = _class
	
	__rectNode.border_color = Color.WHITE
	__rectNode.border_width = 4.0
	__rectNode.editor_only = false
	__rectNode.size = Vector2(512, 320)
	__rectNode.pivot_offset = __rectNode.size * 0.5
	__rectNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(__rectNode)
	add_child(__teamsNode)


func __newTeam(_name: String) -> Team:
	var team: Team = Team.new(_name)
	return team


func _process(delta: float) -> void:
	if is_instance_valid(__focus):
		pass # FOCUS ANIMATION
	__rectNode.scale = Vector2.ONE + ((Vector2.ONE * 4) * sin(Time.get_ticks_msec() * 0.005)) / __rectNode.size


func turnProccess(_time: float) -> void: # turn = floor(_time)
	pass


func attachTeam(_name: String) -> void:
	var team: Team = __newTeam(_name)
	__teams.append(team)


func attachUnit(_tIdx: int, _class: String) -> void:
	__teams[_tIdx].attachUnit(_class)


func addTeam(idx: int) -> void:
	var team: Team = __teams[idx]
	__teamsNode.add_child(team)


func addUnit(_tIdx: int, _uIdx: int) -> void:
	__teams[_tIdx].addUnit(_uIdx)


func focusTeam(idx: int) -> void:
	if is_instance_valid(__focus):
		pass
	__focus = __teams[idx]
