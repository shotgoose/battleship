class_name BoatPath
extends RefCounted

var points := PackedVector2Array()
var dists := PackedFloat32Array() # dists[i] = arc length from points[0] to points[i]
var dirs := PackedVector2Array() # dirs[i] = vector pointing from points[i] to points[i + 1]
var waypoints := PackedVector2Array()

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

func _sample(c: Vector2, radius: float, start_angle: float, sweep: float, s: float, target: Vector2, step: float) -> void:
	waypoints.append(target)
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

func is_empty() -> bool:
	return points.is_empty()

func length() -> float:
	return 0.0 if dists.is_empty() else dists[-1]
	
func size() -> int:
	return points.size()
	
func waypoints_size() -> int:
	return waypoints.size()
	
func get_point(index: int) -> Vector2:
	return points[index]
	
func get_dist(index: int) -> float:
	return dists[index]
	
func get_dir(index: int) -> Vector2:
	return dirs[index]
	
func get_dist_at(point: Vector2) -> float:
	var i = points.bsearch(point)
	if i == -1:
		return 0
	return dists[i]
	
func get_dir_at(point: Vector2) -> Vector2:
	var i = points.bsearch(point)
	if i == -1:
		return Vector2.ZERO
	return dirs[i]
	
func get_waypoint(index: int) -> Vector2:
	return waypoints[index]
	
func end_point() -> Vector2:
	return points[-1]
	
func end_heading() -> Vector2:
	return dirs[-1]

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
	for i in other.waypoints.size():
		waypoints.append(other.waypoints[i])
		
func remove_path_to(target: Vector2) -> void:
	var i = points.bsearch(target)
	var j = waypoints.bsearch(target)
	if i == -1 or j == -1:
		return
	points = points.slice(i)
	waypoints = waypoints.slice(j)
	
func clear() -> void:
	points.clear()
	dists.clear()
	dirs.clear()
	waypoints.clear()
	
func append_new(other: BoatPath) -> BoatPath:
	var new = BoatPath.new()
	new.append_path(self)
	new.append_path(other)
	return new
