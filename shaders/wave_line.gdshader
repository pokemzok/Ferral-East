shader_type canvas_item;

uniform sampler2D existing_screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform float frequency: hint_range(0.0, 60.0) = 60.0;
uniform float strength: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 original_color = texture(existing_screen_texture, SCREEN_UV, 0.0).rgb;
	
	vec2 new_uv = SCREEN_UV;
	new_uv.x += sin(new_uv.y * frequency + TIME) * 0.005;

	vec3 modified_color = textureLod(existing_screen_texture, new_uv, 0.0).rgb;
	
	vec3 new_color = mix(original_color, modified_color, strength);
	COLOR.rgb = new_color;
}
