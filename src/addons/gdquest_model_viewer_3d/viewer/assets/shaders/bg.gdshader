shader_type spatial;
render_mode unshaded;

uniform sampler2D logo_sampler_sdf : repeat_disable;
uniform float logo_scale = 1.0;
uniform float logo_opacity = 0.1;
uniform vec3 border_color : source_color = vec3(0.0);
uniform vec3 center_color : source_color = vec3(0.08);
uniform vec2 ratio = vec2(1.0);
const float logo_ratio = 1312.0 / 404.0;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	ALBEDO = vec3(mix(center_color, border_color, distance(vec2(0.5), UV)));
	ALBEDO += smoothstep(0.45,0.5,texture(logo_sampler_sdf, ((UV - vec2(0.5, 0.2)) * vec2(1.0, logo_ratio) * ratio) * logo_scale + 0.5).a) * logo_opacity;
}
