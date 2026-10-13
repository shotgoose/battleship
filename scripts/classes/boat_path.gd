class_name BoatPath
extends RefCounted

var points := PackedVector2Array()
var dists := PackedFloat32Array() # dists[i] = arc length from points[0] to points[i]
var dirs := PackedVector2Array() # dirs[i] = vector pointing from points[i] to points[i + 1]

static func plan(start: Vector2, heading: Vector2, target: Vector2, radius: float, step := 0.5) -> BoatPath:
	var result := BoatPath.new()
	var best_len := INF
	var best_c := Vector2.ZERO
	var best_start_angle := 0.0
	var best_sweep := 0.0
	var best_s := 1.0

	for s: float in [-1.0, 1.0]:
		var c := start + s * radius * Vector2(-heading.y, heading.x)
		var to_t := target - c
		var dist := to_t.length()
		if dist < radius:
			continue
		var theta := acos(radius / dist)
		var exit_angle := to_t.angle() - s * theta
		var exit_point := c + Vector2.from_angle(exit_angle) * radius
		var start_angle := (start - c).angle()
		var sweep := fposmod((exit_angle - start_angle) * s, TAU)
		if sweep > TAU - 0.001:
			sweep = 0.0
		var leng := sweep * radius + exit_point.distance_to(target)
		if leng < best_len:
			best_len = leng
			best_c = c
			best_start_angle = start_angle
			best_sweep = sweep
			best_s = s

	if best_len < INF:
		result._sample(best_c, radius, best_start_angle, best_sweep, best_s, target, step)
	return result
	
static func merge(array: Array[BoatPath]) -> BoatPath:
	var merged = BoatPath.new()
	for path in array:
		merged.append_path(path)
	return merged
	
static func find_markers(array: Array[BoatPath]) -> BoatPath:
	var m := BoatPath.new()
	var dist := 0.0
	for path in array:
		dist += path.get_dist(-1)
		m._append(path.get_point(-1), dist, Vector2.ZERO)
	return m

func _sample(c: Vector2, radius: float, start_angle: float, sweep: float, s: float, target: Vector2, step: float) -> void:
	var arc_steps := int(sweep * radius / step)
	var rad_step := s * step / radius
	for i in arc_steps:
		_push(c + Vector2.from_angle(start_angle + rad_step * i) * radius, Vector2.from_angle(start_angle + rad_step * i + PI / 2))

	var exit_point := c + Vector2.from_angle(start_angle + s * sweep) * radius
	var line_len := exit_point.distance_to(target)
	var dir := (target - exit_point).normalized()
	_push(exit_point, dir)
	for i in range(1, int(line_len / step) + 1):
		_push(exit_point + dir * step * i, dir)
	if points[-1].distance_to(target) > 0.001:
		_push(target, dir)

func _push(point: Vector2, dir: Vector2) -> void:
	var dist := 0.0
	if points.size() > 0:
		dist = dists[-1] + points[-1].distance_to(point)
	points.append(point)
	dists.append(dist)
	dirs.append(dir)
	
func _append(point: Vector2, dist: float, dir: Vector2) -> void:
	points.append(point)
	dists.append(dist)
	dirs.append(dir)

func is_empty() -> bool:
	return points.is_empty()

func length() -> float:
	return 0.0 if dists.is_empty() else dists[-1]
	
func size() -> int:
	return points.size()
	
func get_point(index: int) -> Vector2:
	return points[index]
	
func get_dist(index: int) -> float:
	return dists[index]
	
func get_dir(index: int) -> Vector2:
	return dirs[index]

func append_path(other: BoatPath) -> void:
	if other == null or other.is_empty():
		return
	var offset := length()
	var first := 0
	if not is_empty() and points[-1].is_equal_approx(other.points[0]):
		first = 1  # skip the duplicated join point
	for i in range(first, other.points.size()):
		points.append(other.points[i])
		dists.append(offset + other.dists[i])
		dirs.append(other.dirs[i])
		
func append_marker(other: BoatPath) -> void:
	if other == null or other.is_empty():
		return
	var dist = other.get_dist(-1) + dists[-1] if !dists.is_empty() else other.get_dist(-1)
	points.append(other.get_point(-1))
	dists.append(dist)
	dirs.append(Vector2.ZERO)
