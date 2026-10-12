class_name PathPreview
extends MultiMeshInstance3D

const DASH_HEIGHT := 0.02
const DASH_WIDTH := .12
const DASH_LENGTH := 0.3
const DASH_OFFSET := 1
const MAX_DASHES := 512

const MAT = preload("res://materials/path.tres")
const COLOR_OK := Color(0.2, 0.9, 0.3)
const COLOR_SHORT := Color(0.2, 0.2, 0.5)
const COLOR_OVER := Color(1.0, 0.2, 0.2)
const COLOR_NOTFOCUS_ALLY := Color(0.2, 0.2, 0.2)
const COLOR_NOTFOCUS_ENEMY := Color(0.5, 0.2, 0.25)

func _ready() -> void:
	var mesh = BoxMesh.new()
	var mm = MultiMesh.new()
	
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	mm.use_colors = true
	mm.instance_count = MAX_DASHES
	mm.visible_instance_count = 0
	multimesh = mm
	material_override = MAT

func draw_path(path: BoatPath, r: TravelRange, f: bool) -> void:
	var dashes = min(path.size(), MAX_DASHES)
	for i in dashes:
		multimesh.set_instance_transform(i, _dash_transform(path.get_point(i), path.get_dir(i)))
		multimesh.set_instance_color(i, _color_for(path.get_dist(i), r, f))
	multimesh.visible_instance_count = dashes

func _dash_transform(pos: Vector2, dir: Vector2) -> Transform3D:
	var x := Vector3(dir.x, 0, dir.y)
	var y := Vector3.UP
	var z := x.cross(y)
	return Transform3D(Basis(x * DASH_LENGTH, y * DASH_HEIGHT, z * DASH_WIDTH), Vector3(pos.x, DASH_OFFSET, pos.y))
	
func _color_for(dist: float, r: TravelRange, f: bool) -> Color:
	if !f: return COLOR_NOTFOCUS_ALLY
	if dist < r.min_value: return COLOR_SHORT
	if dist > r.max_value: return COLOR_OVER
	return COLOR_OK
