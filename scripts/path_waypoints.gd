class_name PathWaypoints
extends MultiMeshInstance3D

const MAT = preload("res://materials/path.tres")

const MAX_MARKERS := 64
const ARM_WIDTH := .2
const ARM_LENGTH := 1
const CROSS_HEIGHT := 0.03
const CROSS_OFFSET := 1.1

const COLOR_OK := Color(0.2, 0.9, 0.3)
const COLOR_SHORT := Color(0.2, 0.2, 0.5)
const COLOR_OVER := Color(1.0, 0.2, 0.2)
const COLOR_NOTFOCUS_ALLY := Color(0.2, 0.2, 0.2)
const COLOR_NOTFOCUS_ENEMY := Color(0.5, 0.2, 0.25)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var st := SurfaceTool.new()
	var arm := BoxMesh.new()
	var mm := MultiMesh.new()
	arm.size = Vector3(ARM_LENGTH, CROSS_HEIGHT, ARM_WIDTH)
	st.append_from(arm, 0, Transform3D(Basis(Vector3.UP, deg_to_rad(45)), Vector3.ZERO))
	st.append_from(arm, 0, Transform3D(Basis(Vector3.UP, deg_to_rad(-45)), Vector3.ZERO))

	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = st.commit()
	mm.use_colors = true
	mm.instance_count = MAX_MARKERS
	mm.visible_instance_count = 0
	multimesh = mm
	material_override = MAT

func draw_markers(path: BoatPath, r: TravelRange, f: bool) -> void:
	var markers = min(path.waypoints_size(), MAX_MARKERS)
	for i in markers:
		var j = path.get_waypoint(i)
		var point = path.get_point(j)
		multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(point.x, CROSS_OFFSET, point.y)))
		multimesh.set_instance_color(i, _color_for(path.get_dist(j), r, f))
	multimesh.visible_instance_count = markers

func _color_for(dist: float, r: TravelRange, f: bool) -> Color:
	if !f: return COLOR_NOTFOCUS_ALLY
	if dist < r.min_value: return COLOR_SHORT
	if dist > r.max_value: return COLOR_OVER
	return COLOR_OK
