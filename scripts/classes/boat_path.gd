class_name BoatPath

static func plan(start: Vector2, heading: Vector2, target: Vector2, radius: float, step := 0.5) -> PackedVector2Array:	
	var best := PackedVector2Array()
	var best_len = INF
	for s : float in [-1.0, 1.0]:
		var c : Vector2 = start + s * radius * Vector2(-heading.y, heading.x)
		var to_t := target - c
		var dist := to_t.length()
		if dist < radius:
			continue
		var theta := acos( radius / dist )
		var exit_angle := to_t.angle() - s * theta
		var exit_point := c + Vector2.from_angle(exit_angle) * radius
		var start_angle := (start - c).angle()
		var sweep := fposmod((exit_angle - start_angle) * s, TAU)
		if sweep > TAU - 0.001:
			sweep = 0.0
		var length = sweep * radius + exit_point.distance_to(target)
		if length < best_len:
			best_len = length
			best = _sample(c, radius, start_angle, sweep, s, target, step)
	return best;
	
static func _sample(c: Vector2, radius: float, start_angle: float, sweep: float, s: float, target: Vector2, step: float) -> PackedVector2Array:
	var path = PackedVector2Array()
	var circle_steps := int(sweep * radius / step)
	var rad_step := s * step / radius
	
	for i in circle_steps:
		var point : Vector2 = c + Vector2.from_angle(start_angle + rad_step * i) * radius
		path.append(point)
		
	var exit_point := c + Vector2.from_angle(start_angle + s * sweep) * radius
	var line_steps := int(exit_point.distance_to(target) / step)
	var line_dir = (target - exit_point).normalized()
	
	for i in line_steps:
		var point : Vector2 = exit_point + line_dir * step * i
		path.append(point)
		
	path.append(target)
	return path
		
