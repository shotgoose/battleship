class_name Player
extends RefCounted

var id: int
var color: Color

func _init(p_id: int, p_color: Color) -> void:
	id = p_id
	color = p_color
