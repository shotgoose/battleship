class_name ChartingState
extends InputState

var _last_mouse := Vector2.INF
var _last_cam_xform := Transform3D()
var _preview: BoatPath

func enter() -> void:
	controller.clear_hover()
	_invalidate()
	
func exit() -> void:
	if is_instance_valid(controller.selected_unit):
		controller.selected_unit.draw_path()

func update(_delta: float) -> void:
	if not is_instance_valid(controller.selected_unit):
		controller.set_state(controller.basic_state)
		return
	var camera := controller.get_viewport().get_camera_3d()
	if camera == null:
		return
	var mouse := controller.get_viewport().get_mouse_position()
	var xform := camera.global_transform
	if mouse == _last_mouse and xform == _last_cam_xform:
		return
	_last_mouse = mouse
	_last_cam_xform = xform
	_preview = controller.get_path_to_cursor()
	controller.selected_unit.draw_path(_preview)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if _preview.size() > 0:
			controller.selected_unit.add_path(_preview)
	if event.is_action_pressed("alt select"):
		controller.selected_unit.delete_path(-1)
		_invalidate()
	if event.is_action_pressed("reset"):
		controller.selected_unit.clear_path()
		_invalidate()
	if event.is_action_pressed("chart"):
		controller.set_state(controller.basic_state)
		
func _invalidate() -> void:
	_last_mouse = Vector2.INF
