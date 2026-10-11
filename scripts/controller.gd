extends Node

const UNIT_LAYER := 1 << 1 # layer 2
const GROUND_LAYER := 1 << 0 # layer 1

var selected_unit: Node;
var hovered_unit: Node;
var preview_path: PackedVector2Array;

enum InputMode {
	basic,
	charting,
}

var input_mode : InputMode

func _ready() -> void:
	input_mode = InputMode.basic

func _unhandled_input(event: InputEvent) -> void:
	match input_mode:
		InputMode.basic:
			if event.is_action_pressed("select"):
				_handle_select_unit()
			if event.is_action_pressed("chart"):
				if is_instance_valid(selected_unit):
					input_mode = InputMode.charting
					_handle_path_update()
		InputMode.charting:
			if event.is_action_pressed("select"):
				_handle_path_select()
			if event.is_action_pressed("alt select"):
				selected_unit.delete_path(-1)
				_handle_path_update()
			if event.is_action_pressed("reset"):
				selected_unit.clear_path()
				_handle_path_update()
			if event is InputEventMouseMotion:
				_handle_path_update()
			if event.is_action_pressed("chart"):
				input_mode = InputMode.basic
				selected_unit.draw_path()

func _process(delta) -> void:
	_handle_hover()

func _raycast(mask: int) -> Dictionary:
	var camera := get_viewport().get_camera_3d()
	if camera == null: return {}
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(from, to, mask)
	return camera.get_world_3d().direct_space_state.intersect_ray(query)

func _handle_select_unit() -> void:
	match input_mode:
		InputMode.basic:
			var hit := _raycast(UNIT_LAYER)
			_clear_selection()
			if hit:
				_select_unit(hit.collider)
		InputMode.charting:
			pass

func _handle_hover() -> void:
	var hit := _raycast(UNIT_LAYER)
	var unit = hit.collider if hit else null
	if unit == hovered_unit:
		return
	_clear_hover()
	if unit:
		_hover_unit(unit)

func _handle_path_update() -> void:
	selected_unit.draw_path(_get_path())
		
func _handle_path_select() -> void:
	var path := _get_path()
	if path.size() > 0:
		selected_unit.add_path(path)

func _select_unit(unit: Node) -> void:
	selected_unit = unit
	unit.set_selected(true)
	
func _get_path() -> PackedVector2Array:
	var hit := _raycast(GROUND_LAYER)
	if hit.is_empty():
		return PackedVector2Array()
	var pos : Vector3 = hit.position
	var target := Vector2(pos.x, pos.z)
	if is_instance_valid(selected_unit):
		return BoatPath.plan(selected_unit.start, selected_unit.start_heading, target, selected_unit.stats.turn_radius)
	return PackedVector2Array()

func _hover_unit(unit: Node) -> void:
	hovered_unit = unit
	unit.set_hovered(true)

func _clear_selection() -> void:
	if is_instance_valid(selected_unit):
		selected_unit.set_selected(false)
	selected_unit = null

func _clear_hover() -> void:
	if is_instance_valid(hovered_unit):
		hovered_unit.set_hovered(false)
	hovered_unit = null
