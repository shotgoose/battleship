shader_type spatial;
render_mode cull_front, unshaded;

uniform float outline_width : hint_range(1, 1.5) = 1.1;
uniform vec4 outline_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX *= outline_width;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = outline_color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
