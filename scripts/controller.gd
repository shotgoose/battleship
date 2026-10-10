extends Node

const UNIT_LAYER := 1 << 1 # layer 2
const GROUND_LAYER := 1 << 0 # layer 1

var selected_unit: Node;
var hovered_unit: Node;
var preview_path: PackedVector2Array;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		_handle_select()
	if event.is_action_pressed("command"):
		_handle_command()
	if event is InputEventMouseMotion:
		_handle_path()

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
	
func _handle_select() -> void:
	var hit := _raycast(UNIT_LAYER)
	clear_selection()
	if hit:
		select_unit(hit.collider)
	
func _handle_hover() -> void:
	var hit := _raycast(UNIT_LAYER)
	var unit = hit.collider if hit else null
	if unit == hovered_unit:
		return
	clear_hover()
	if unit:
		hover_unit(unit)
		
func _handle_command() -> void:
	pass
	
func _handle_path() -> void:
	var hit := _raycast(GROUND_LAYER)
	if hit.is_empty():
		return
	var pos : Vector3 = hit.position
	var target := Vector2(pos.x, pos.z)
	if is_instance_valid(selected_unit):
		preview_path = BoatPath.plan(selected_unit.ground_position, selected_unit.heading, target, selected_unit.stats.turn_radius)
		selected_unit.draw_path(preview_path)
		
func select_unit(unit: Node) -> void:
	selected_unit = unit
	unit.set_selected(true)
	
func hover_unit(unit: Node) -> void:
	hovered_unit = unit
	unit.set_hovered(true)
	
func clear_selection() -> void:
	if is_instance_valid(selected_unit):
		selected_unit.set_selected(false)
	selected_unit = null
		
func clear_hover() -> void:
	if is_instance_valid(hovered_unit):
		hovered_unit.set_hovered(false)
	hovered_unit = null
