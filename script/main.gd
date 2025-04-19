extends Node

#LIAM, LUDO, LINO, MYRON, MYR, KYRO, SIRO, TYRON, VARYON, BYNARO, PANTALUNA

var __fields: Array[Field]


func _init() -> void:
	attachField("normal")


func _ready() -> void:
	addField(0)


func _input(event: InputEvent) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		setCameraPosition(getCameraPosition() + event.relative)


func _process(delta: float) -> void:
	$DebugLayer/Label.text = str(
		getCameraPosition()
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


func attachField(_class) -> void:
	var field: Field = Field.new(_class)
	
	__fields.append(field)


func addField(idx: int) -> void:
	var field: Field = __fields[idx]
	
	$Fields.add_child(field)


func focusField(idx: int) -> void:
	pass
