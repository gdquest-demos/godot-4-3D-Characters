shader_type canvas_item;

void fragment() {
	COLOR.a *= smoothstep(0.5, 0.49, distance(vec2(0.5), UV));
}
