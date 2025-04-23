extends Node2D

const __test_world_data: Dictionary = {
	"main" = { "position" = Vector2i(0, 0), "size" = Vector2i(8, 5) },
	"field" = [
		{
			"position" = Vector2i(1, 0), "size" = Vector2i(6, 5),
			"season" = "spring",
			"team" = {
				"team0" = {
					"position" = Vector2i(0, 0), "size" = Vector2i(6, 2),
					"unit" = [
						{ "type" = "normal", "position" = Vector2i(1, 1), "size" = Vector2i(1, 1) },
						{ "type" = "normal", "position" = Vector2i(3, 1), "size" = Vector2i(1, 1) },
						{ "type" = "normal", "position" = Vector2i(5, 1), "size" = Vector2i(1, 1) }
					]
				},
				"team1" = {
					"position" = Vector2i(0, 3), "size" = Vector2i(6, 2),
					"unit" = [
						{ "type" = "normal", "position" = Vector2i(1, 0), "size" = Vector2i(1, 1) },
						{ "type" = "normal", "position" = Vector2i(3, 0), "size" = Vector2i(1, 1) },
						{ "type" = "normal", "position" = Vector2i(5, 0), "size" = Vector2i(1, 1) }
					]
				}
			}
		}
	]
}

static var __mouse: Vector2

var size: Vector2i = Vector2i(8, 8)

var __debug: Dictionary


func _init() -> void:
	set_world(__test_world_data)
	
	return
	
	add_child(Field.new("Spring"))
	add_child(Team.new("team0"))
	
	for i in 16:
		var unit: Unit = Unit.new("normal")
		add_child(unit)
		await unit.move(Vector2.ONE, 2)
		await unit.move(Vector2.RIGHT, i % 4)
		await unit.move(Vector2.DOWN, floori(i / 4.0))


func _ready() -> void:
	set_camera_position(Vector2.ZERO)
	set_camera_zoom(2.0)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		pass#["mouse"] = event.position
	elif event is InputEventScreenTouch:
		#__debug["mouse"] = get_camera_position() + event.position * (1.0 / get_camera_zoom())
		var ev_loc: InputEventScreenTouch = make_input_local(event)
		if event.is_pressed():
			if event.double_tap:
				set_camera_zoom(wrapf(get_camera_zoom() + 0.5, 0.5, 2.5))
				return
			
			var units: Array[Unit]
			units.append_array(get_tree().get_nodes_in_group("unit"))
			
			for unit in units:
				if Rect2(unit.global_position + Vector2(8, 8), Vector2(64 - 16, 64 - 16)).has_point(ev_loc.position):
					Unit.focused = unit
					break
			
		else:
			var unit: Unit = Unit.focused
			if is_instance_valid(unit):
				var dir: Vector2 = unit.global_position.direction_to(__mouse)
				var dis: float = unit.global_position.distance_to(__mouse)
				var deg: int = absi(int(Vector2.UP.dot(dir) * 90))
				var vector: Vector2 = dir
				
				if deg in [0, 63, 90]:
					if deg == 63:
						vector *= 1.41421
					
					unit.move(vector, roundi((dis if not deg == 63 else (dis / 1.41421)) / 64.0), 0.1)
				
				Unit.focused = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var local_event: InputEventScreenDrag = make_input_local(event)
		if not is_instance_valid(Unit.focused):
			set_camera_position(get_camera_position() - event.relative * (1.0 /get_camera_zoom()))
		else:
			var mouse: Vector2 = (local_event.position.clamp(Vector2.ZERO, Vector2(512 - 32, 512 - 32)) / Vector2(64, 64)).floor() * 64
			var dir: Vector2 = Unit.focused.global_position.direction_to(mouse)
			var deg: int = absi(int(Vector2.UP.dot(dir) * 90))
			
			if deg in [0, 63, 90]:
				__mouse = mouse
			#__debug["dot"] = absi(int(Vector2.UP.dot(__mouse.direction_to(Unit.focused.position)) * 90))


func _process(delta: float) -> void:
	var to_debug: String = str(delta, "\n")
	for _key in __debug:
		to_debug += str(_key, ": ", __debug[_key], "\n")
	$DBLayer/Label.text = to_debug
	
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2(0, 0), size * 64), Color.RED, false, 10)
	var unit: Unit = Unit.focused
	
	if is_instance_valid(unit):
		draw_rect(Rect2(unit.global_position + Vector2(24, 24), Vector2(16, 16)), Color.VIOLET, true)
		
		if absi(int(Vector2.UP.dot(__mouse.direction_to(Unit.focused.global_position)) * 90)) in [0, 63, 90]:
			draw_rect(Rect2(__mouse + Vector2(24, 24), Vector2(16, 16)), Color.VIOLET, true)
			draw_line(unit.global_position + Vector2(32, 32), __mouse + Vector2(32, 32), Color.VIOLET, 2.0)
		

func set_world(_data: Dictionary) -> void:
	position = _data.main.position * 64
	size = _data.main.size
	
	for f: Dictionary in _data.field as Array:
		var fn: Field = Field.new(f.season)
		fn.position = f.position * 64
		fn.size = f.size
		
		for t: String in f.team as Dictionary:
			var tn: Team = Team.new(t)
			tn.position = f.team[t].position * 64
			tn.size = f.team[t].size
			
			for u: Dictionary in f.team[t].unit as Array:
				var un: Unit = Unit.new(u.type)
				un.position = u.position * 64
				un.size = u.size
				
				tn.add_child(un)
			
			fn.add_child(tn)
		
		add_child(fn)
		


func get_world() -> Dictionary:
	var data: Dictionary = {}
	
	return data


func set_camera_zoom(_zoom: float) -> void:
	$Camera.zoom = Vector2(_zoom, _zoom)
	$BGLayer/Grid.material.set_shader_parameter("zoom", _zoom)
	
	#__debug["zoom"] = _zoom


func get_camera_zoom() -> float:
	return $Camera.zoom.x


func set_camera_position(_position: Vector2) -> void:
	var grid: ShaderMaterial = $BGLayer/Grid.material
	
	$Camera.position = _position
	grid.set_shader_parameter("offset", _position)
	
	#__debug["pos"] = _position


func get_camera_position() -> Vector2:
	return $Camera.position


func _on_turn_pressed() -> void:
	$UILayer/Turn.text = str($UILayer/Turn.text.to_int() + 1)
