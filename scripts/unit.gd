class_name Unit
extends CharacterBody3D

@export var stats : UnitStats

var is_selected : bool = false
var is_hovered : bool = false
var planned_path := PackedVector2Array()

const OUTLINE_HOVER := preload("res://materials/outline_hover.tres")
const OUTLINE_SELECT := preload("res://materials/outline_select.tres")

@onready var model : Node3D = $Model

func set_selected(value: bool) -> void:
	is_selected = value
	_update_outline()
	
func set_hovered(value: bool) -> void:
	is_hovered = value
	_update_outline()

func pathfind() -> void:
	pass

func _update_outline() -> void:
	var mat : Material = null
	if is_selected:
		mat = OUTLINE_SELECT
	elif is_hovered:
		mat = OUTLINE_HOVER
	for mesh in model.find_children("*", "MeshInstance3D", true, false):
		mesh.material_overlay = mat
