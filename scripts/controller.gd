class_name Controller
extends Node

const UNIT_LAYER := 1 << 1 # layer 2
const GROUND_LAYER := 1 << 0 # layer 1

var player: Player

var selected_unit: Unit;
var hovered_unit: Unit;
var preview_path: PackedVector2Array;

var input_state: InputState
var basic_state: InputState
var charting_state: InputState
var ready_state: InputState

func _ready() -> void:
	basic_state = BasicState.new(self)
	charting_state = ChartingState.new(self)
	ready_state = ReadyState.new(self)
	player = Player.new(1, Color(0,0,0))
	
	set_state(basic_state)

func _unhandled_input(event: InputEvent) -> void:
	input_state.handle_input(event)

func _process(delta: float) -> void:
	input_state.update(delta)

func _raycast(mask: int) -> Dictionary:
	var camera := get_viewport().get_camera_3d()
	if camera == null: return {}
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(from, to, mask)
	return camera.get_world_3d().direct_space_state.intersect_ray(query)
			
func get_unit_at_cursor() -> Unit:
	var hit := _raycast(UNIT_LAYER)
	if hit.is_empty():
		return null
	return hit.collider as Unit
		
func get_path_to_cursor() -> BoatPath:
	if not is_instance_valid(selected_unit):
		return BoatPath.new()
	var hit := _raycast(GROUND_LAYER)
	if hit.is_empty():
		return BoatPath.new()
	var pos : Vector3 = hit.position
	var target := Vector2(pos.x, pos.z)
	return BoatPath.plan(selected_unit.start, selected_unit.start_heading, target, selected_unit.turn_radius)
	
func select_unit(unit: Node) -> void:
	clear_selection()
	selected_unit = unit
	unit.set_selected(true)
	
func hover_unit(unit: Node) -> void:
	clear_hover()
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
	
func set_state(new_state: InputState) -> void:
	if new_state == input_state:
		return
	if input_state:
		input_state.exit()
	input_state = new_state
	new_state.enter()
