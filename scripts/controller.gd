extends Node

const UNIT_LAYER := 1 << 1 # layer 2
const GROUND_LAYER := 1 <<0 # layer 1

var selected_unit: Node;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		_handle_select();

func _raycast() -> Dictionary:
	var camera := get_viewport().get_camera_3d();
	var mouse_pos := get_viewport().get_mouse_position();
	var from := camera.project_ray_origin(mouse_pos);
	var to := from + camera.project_ray_normal(mouse_pos) * 1000.0;
	var query := PhysicsRayQueryParameters3D.create(from, to);
	return camera.get_world_3d().direct_space_state.intersect_ray(query);
	
func _handle_select() -> void:
	var hit := _raycast();
	clear_selection()
	if hit:
		select_unit(hit.collider);
	print_debug(selected_unit);
		
func select_unit(unit: Node) -> void:
	selected_unit = unit;
	unit.set_selected(true);
	
func clear_selection() -> void:
	if selected_unit:
		selected_unit.set_selected(false);
		selected_unit = null;
