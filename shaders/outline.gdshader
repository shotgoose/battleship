shader_type spatial;
render_mode cull_front, unshaded;

uniform float outline_width : hint_range(1, 1.5) = 1.1;
uniform vec4 outline_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);

void vertex() {
	VERTEX *= outline_width;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
