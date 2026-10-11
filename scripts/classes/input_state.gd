class_name InputState
extends RefCounted

var controller: Controller

func _init(ctrl: Controller):
	controller = ctrl

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func handle_input(_event: InputEvent) -> void:
	pass
	
