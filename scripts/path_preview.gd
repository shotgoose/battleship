class_name PathPreview
extends MultiMeshInstance3D

const DASH_HEIGHT := 0.02
const DASH_WIDTH := .08
const DASH_LENGTH := 0.1
const DASH_OFFSET := 1
const MAX_DASHES := 256


const ACTIVE = preload("res://materials/path_active.tres")
const INACTIVE = preload("res://materials/path_inactive.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh = BoxMesh.new()
	var mm = MultiMesh.new()
	
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	mm.instance_count = MAX_DASHES
	mm.visible_instance_count = 0
	multimesh = mm
	
	material_override = ACTIVE

func draw_path(path: PackedVector2Array) -> void:
	if path.size() > MAX_DASHES:
		return
	for i in path.size():
		var dir : Vector2
		if i + 1 < path.size():
			dir = (path.get(i + 1) - path.get(i)).normalized()
		elif i - 1 > 0:
			dir = (path.get(i) - path.get(i - 1)).normalized()
		else:
			continue
		multimesh.set_instance_transform(i, _dash_transform(path.get(i), dir))
	multimesh.visible_instance_count = path.size()
	pass

func _dash_transform(pos: Vector2, dir: Vector2) -> Transform3D:
	var x := Vector3(dir.x, 0, dir.y)
	var y := Vector3.UP
	var z := x.cross(y)
	return Transform3D(Basis(x * DASH_LENGTH, y * DASH_HEIGHT, z * DASH_WIDTH), Vector3(pos.x, DASH_OFFSET, pos.y))
	
