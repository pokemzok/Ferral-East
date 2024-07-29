shader_type canvas_item;
uniform sampler2D existing_screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform float strength: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// OpenGL based
	vec3 original_color = texture(existing_screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 inverted_color = vec3(1.0)- original_color;
	
	vec3 new_color = mix(original_color, inverted_color, strength);
	COLOR.rgb = new_color;
}
