shader_type spatial;
render_mode unshaded;

uniform vec3 grid_color : source_color = vec3(0.0);
uniform float grid_opacity = 0.1;

float grid(vec2 st, float res)
{
  vec2 grid = fract(st*res);
  return (step(0.015,grid.x) * step(0.015,grid.y));
}

void fragment() {
	ALPHA = (1.0 - grid(UV, 10.0)) * smoothstep(0.5, 0.0, distance(vec2(0.5), UV)) * grid_opacity;
	ALBEDO = grid_color;
}
