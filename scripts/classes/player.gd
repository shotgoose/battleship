class_name Player
extends RefCounted

var id: int
var color: Color
var ready: bool

func _init(p_id: int, p_color: Color) -> void:
	id = p_id
	color = p_color
	ready = false
	
func set_ready(status: bool):
	ready = status
