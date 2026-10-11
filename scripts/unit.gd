class_name Unit
extends CharacterBody3D

@export var stats : UnitStats

const OUTLINE_HOVER := preload("res://materials/outline_hover.tres")
const OUTLINE_SELECT := preload("res://materials/outline_select.tres")
const PATH_ACTIVE = preload("res://materials/path_active.tres")
const PATH_INACTIVE = preload("res://materials/path_inactive.tres")

var is_selected : bool = false
var is_hovered : bool = false
var planned_path := Array(PackedVector2Array())
var predicted_path := Array(PackedVector2Array())

@onready var path_preview: PathPreview = %PathPreview

var ground_position: Vector2:
	get: return Vector2(global_position.x, global_position.z)

var heading: Vector2:
	get:
		var f := -global_basis.z
		return Vector2(f.x, f.z).normalized()
		
var start: Vector2:
	get:
		if planned_path.size() > 0:
			return planned_path[-1].get(planned_path[-1].size() - 1)
		else:
			return ground_position
			
var start_heading: Vector2:
	get:
		if planned_path.size() > 0:
			var last_vector: Vector2 = planned_path[-1].get(planned_path[-1].size() - 1)
			var second_to_last_vector : Vector2 = planned_path[-1].get(planned_path[-1].size() - 2)
			return (last_vector - second_to_last_vector).normalized()
		else:
			return heading

@onready var model : Node3D = $Model

func set_selected(value: bool) -> void:
	is_selected = value
	_update_outline()
	_update_path_focus()
	
func set_hovered(value: bool) -> void:
	is_hovered = value
	_update_outline()
	_update_path_focus()
	
func draw_path(preview_path:= PackedVector2Array()) -> void:
	var merged_path = PackedVector2Array()
	for path in planned_path:
		merged_path.append_array(path)
	merged_path.append_array(preview_path)
	path_preview.draw_path(merged_path)
	
func clear_path() -> void:
	planned_path.clear()

func add_path(path: PackedVector2Array):
	planned_path.append(path)

func delete_path(index: int):
	planned_path.pop_at(index)

func _update_outline() -> void:
	var mat : Material = null
	if is_selected:
		mat = OUTLINE_SELECT
	elif is_hovered:
		mat = OUTLINE_HOVER
	for mesh in model.find_children("*", "MeshInstance3D", true, false):
		mesh.material_overlay = mat
		
func _update_path_focus() -> void:
	var mat : Material = null
	if is_selected:
		mat = PATH_ACTIVE
	else:
		mat = PATH_INACTIVE
	$PathPreview.material_override = mat
