extends RigidBody3D

var is_selected = false;
var is_hovered = false;

func set_selected(value: bool) -> void:
	is_selected = value;
	
func set_hovered(value: bool) -> void:
	is_hovered = value;
