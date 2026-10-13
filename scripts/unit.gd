class_name Unit
extends CharacterBody3D

@export var stats : UnitStats

const OUTLINE_HOVER := preload("res://materials/outline_hover.tres")
const OUTLINE_SELECT := preload("res://materials/outline_select.tres")

var is_selected : bool = false
var is_hovered : bool = false
var planned_path := BoatPath.new()
var speed: float = 50
var type: UnitType = UnitType.ALLY

@onready var path_preview: PathPreview = %PathPreview
@onready var path_waypoints: PathWaypoints = %PathWaypoints

enum UnitType {
	ALLY,
	ENEMY,
}

var ground_position: Vector2:
	get: return Vector2(global_position.x, global_position.z)

var heading: Vector2:
	get:
		var f := -global_basis.z
		return Vector2(f.x, f.z).normalized()
		
var start: Vector2:
	get:
		if planned_path.size() > 0:
			return planned_path.get_point(-1)
		else:
			return ground_position
			
var start_heading: Vector2:
	get:
		if planned_path.size() > 0:
			return planned_path.get_dir(-1)
		else:
			return heading

var turn_radius: float:
	get:
		return stats.base_turn_radius + speed * stats.turn_radius_speed_coeff

var travel_range: TravelRange:
	get:
		var min_val = maxf(0.0, speed - stats.max_deceleration)
		var max_val = minf(stats.top_speed, speed + stats.max_acceleration)
		return TravelRange.new(min_val, max_val)
		
var planned_range: float:
	get:
		return planned_path.length()

@onready var model : Node3D = $Model

func set_selected(value: bool) -> void:
	is_selected = value
	_update_outline()
	draw_path()
	
func set_hovered(value: bool) -> void:
	is_hovered = value
	_update_outline()
	
func draw_path(preview_path := BoatPath.new()) -> void:
	var preview = planned_path.append_new(preview_path)
	path_preview.draw_path(preview, travel_range, is_selected)
	path_waypoints.draw_markers(preview, travel_range, is_selected)
	
func clear_path() -> void:
	planned_path.clear()

func add_path(path: BoatPath) -> void:
	if travel_range.within_range(planned_range + path.length()):
		planned_path.append_path(path)

func delete_path(index: int) -> void:
	planned_path.remove_path_to(planned_path.get_waypoint(index))
	
func verify_path() -> void:
	if not travel_range.contains(planned_range):
		clear_path()

func _update_outline() -> void:
	var mat : Material = null
	if is_selected:
		mat = OUTLINE_SELECT
	elif is_hovered:
		mat = OUTLINE_HOVER
	for mesh in model.find_children("*", "MeshInstance3D", true, false):
		mesh.material_overlay = mat
