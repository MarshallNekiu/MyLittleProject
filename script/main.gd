extends Node2D

static var __mouse: Vector2

var __debug: Dictionary


func _init() -> void:
	for i in 16:
		var unit: Unit = Unit.new("normal")
		add_child(unit)
		await unit.move(Vector2.ONE, 1)
		await unit.move(Vector2.RIGHT, i % 4)
		await unit.move(Vector2.DOWN, floori(i / 4.0))


func _ready() -> void:
	setCameraPosition(Vector2.ZERO)
	setCameraZoom(2.0)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		__debug["mouse"] = event.position
	elif event is InputEventScreenTouch:
		__debug["mouse"] = getCameraPosition() + event.position * (1.0 / getCameraZoom())
		if event.is_pressed():
			if event.double_tap:
				setCameraZoom(wrapf(getCameraZoom() + 0.5, 0.5, 2.5))
		else:
			var unit: Unit = Unit.focused
			if is_instance_valid(unit):
				var dir: Vector2 = unit.position.direction_to(__mouse)
				var dis: float = unit.position.distance_to(__mouse)
				var deg: int = absi(int(Vector2.UP.dot(dir) * 90))
				var vector: Vector2 = dir
				
				if deg in [0, 63, 90]:
					if deg == 63:
						vector *= 1.41421
					
					unit.move(vector, roundi((dis if not deg == 63 else (dis / 1.41421)) / 64.0))
				
				Unit.focused = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var localEvent: InputEventScreenDrag = make_input_local(event)
		if not is_instance_valid(Unit.focused):
			setCameraPosition(getCameraPosition() - event.relative * (1.0 /getCameraZoom()))
		else:
			var mouse: Vector2 = (localEvent.position.clamp(Vector2.ZERO, Vector2(1280 - 32, 768 - 32)) / Vector2(64, 64)).floor() * 64
			var dir: Vector2 = Unit.focused.position.direction_to(mouse)
			var deg: int = absi(int(Vector2.UP.dot(dir) * 90))
			
			if deg in [0, 63, 90]:
				__mouse = mouse
			__debug["dot"] = absi(int(Vector2.UP.dot(__mouse.direction_to(Unit.focused.position)) * 90))


func _process(delta: float) -> void:
	var toDebug: String = str(delta, "\n")
	for _key in __debug:
		toDebug += str(_key, ": ", __debug[_key], "\n")
	$DBLayer/Label.text = toDebug
	
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2(0, 0), Vector2(1280, 768)), Color.RED, false, 8)
	var unit: Unit = Unit.focused
	
	if is_instance_valid(unit):
		draw_rect(Rect2(unit.position + Vector2(24, 24), Vector2(16, 16)), Color.VIOLET, true)
		
		if absi(int(Vector2.UP.dot(__mouse.direction_to(Unit.focused.position)) * 90)) in [0, 63, 90]:
			draw_rect(Rect2(__mouse + Vector2(24, 24), Vector2(16, 16)), Color.VIOLET, true)
			draw_line(unit.position + Vector2(32, 32), __mouse + Vector2(32, 32), Color.VIOLET, 2.0)
		


func setCameraZoom(_zoom: float) -> void:
	$Camera.zoom = Vector2(_zoom, _zoom)
	$BGLayer/Grid.material.set_shader_parameter("zoom", _zoom)
	
	__debug["zoom"] = _zoom


func getCameraZoom() -> float:
	return $Camera.zoom.x


func setCameraPosition(_position: Vector2) -> void:
	var grid: ShaderMaterial = $BGLayer/Grid.material
	
	$Camera.position = _position
	grid.set_shader_parameter("offset", _position)
	
	__debug["pos"] = _position


func getCameraPosition() -> Vector2:
	return $Camera.position
