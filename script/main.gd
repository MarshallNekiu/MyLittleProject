extends Node

var size: Vector2:
	set(x): __rectNode.size = x
	get: return __rectNode.size

var __fields: Array[Field]
var __focus: Field

var __rectNode: ReferenceRect = ReferenceRect.new()
var __fieldsNode: Node2D = Node2D.new()


func _init() -> void:
	attachField("normal")
	attachTeam(0, "player")
	attachUnit(0, 0, "normal")
	
	__rectNode.border_color = Color.RED
	__rectNode.border_width = 8.0
	__rectNode.editor_only = false
	__rectNode.size = Vector2(1280, 768)
	__rectNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(__rectNode)
	add_child(__fieldsNode)


func _ready() -> void:
	addField(0)
	addTeam(0, 0)
	addUnit(0, 0, 0)


func _input(event: InputEvent) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		setCameraPosition(getCameraPosition() + event.relative)


func _process(delta: float) -> void:
	$DebugLayer/Label.text = str(
		getCameraPosition(), "\n",
		"zoom: ", getCameraZoom(), "\n",
		"fields: ", __fields.size()
	)


func _physics_process(delta: float) -> void:
	pass


func setCameraZoom(_zoom: float) -> void:
	$Camera.zoom = Vector2(_zoom, _zoom)
	$CamLayer/Grid.material.set_shader_parameter("zoom", _zoom)


func getCameraZoom() -> float:
	return $Camera.zoom.x


func setCameraPosition(_position: Vector2) -> void:
	var grid: ShaderMaterial = $CamLayer/Grid.material
	
	$Camera.position = _position
	grid.set_shader_parameter("offset", _position)


func getCameraPosition() -> Vector2:
	return $Camera.position


func __newField(_class: String) -> Field:
	var field: Field = Field.new(_class)
	return field


func attachField(_class: String) -> void:
	var field: Field = __newField(_class)
	__fields.append(field)


func attachTeam(_fIdx: int, _name: String) -> void:
	__fields[_fIdx].attachTeam(_name)


func attachUnit(_fidx: int, _tIdx: int, _class) -> void:
	__fields[_fidx].attachUnit(_tIdx, _class)


func addField(idx: int) -> void:
	var field: Field = __fields[idx]
	__rectNode.add_child(field)


func addTeam(_fIdx: int, _tIdx: int) -> void:
	__fields[_fIdx].addTeam(_tIdx)


func addUnit(_fidx: int, _tIdx: int, _uIdx: int) -> void:
	__fields[_fidx].addUnit(_tIdx, _uIdx)


func focusField(idx: int) -> void:
	if is_instance_valid(__focus):
		pass
	__focus = __fields[idx]
