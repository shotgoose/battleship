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
		var len = sweep * radius + exit_point.distance_to(target)
		if len < best_len:
			best_len = len
			best = _sample(c, radius, start_angle, sweep, s, target, step)
	return PackedVector2Array();
		
