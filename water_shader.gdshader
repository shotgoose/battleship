shader_type spatial;
render_mode diffuse_toon, specular_toon;

uniform sampler2D noisemap;
uniform float wave_height = 0.1;
uniform float normal_offset = 0.01;
uniform float plane_size = 2.0;
uniform float tile = 1.0;
uniform float speed = 0.1;

vec2 offset(vec2 uv, float time) {
	return uv * tile + vec2(cos(time * speed), sin(time * speed));
}

float height(vec2 uv, float time) {
	return texture(noisemap, offset(uv, time)).x * wave_height;
}

vec3 normal(vec2 uv, float time) {
	float h = height(uv, time);
	
	float dr = height(uv + vec2(normal_offset, 0.0), time);
	float dl = height(uv - vec2(normal_offset, 0.0), time);
	float du = height(uv + vec2(0.0, normal_offset), time);
	float dd = height(uv - vec2(0.0, normal_offset), time);
	
	float st = normal_offset * plane_size;
	
	return normalize(vec3(dl - dr, 2.0 * st, dd - du));
}

void vertex() {
	vec2 uv = VERTEX.xz / plane_size + 0.5;
	VERTEX.y = height(uv, TIME);
	NORMAL = normal(uv, TIME);
}

void fragment() {
	float fresnel = 1.0 - dot(NORMAL, VIEW);
	ALBEDO = mix(vec3(0.005, 0.025, 0.05), vec3(0.1, 0.1, 0.35), fresnel);
	ROUGHNESS = 0.05;
	RIM = 0.2;
	METALLIC = 0.1;
}
