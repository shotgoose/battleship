class_name BasicState
extends InputState

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(event: InputEvent):
	if event.is_action_pressed("select"):
		_handle_select_unit()
	if event.is_action_pressed("chart"):
		if is_instance_valid(controller.selected_unit):
			controller.set_state(controller.charting_state)

func _handle_select_unit() -> void:
	controller.clear_selection()
	var unit = controller.get_unit_at_cursor() as Unit
	if is_instance_valid(unit):
			controller.select_unit(unit)

func _handle_hover_unit() -> void:
	var unit = controller.get_unit_at_cursor() as Unit
	if unit == controller.hovered_unit:
		return
	controller.clear_hover()
	if is_instance_valid(unit):
		controller.hover_unit(unit)
	
	
