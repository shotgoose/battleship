class_name ReadyState
extends InputState

func enter() -> void:
	controller.clear_selection()
	controller.player.set_ready(true)

func exit() -> void:
	controller.player.set_ready(false)
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ready"):
		controller.set_state(controller.basic_state)
	
