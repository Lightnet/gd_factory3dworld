shader_type spatial;
uniform float speed = 1.0;
uniform vec2 texture_scale = vec2(1.0, 1.0);

void fragment() {
    vec2 uv = UV;
    uv *= texture_scale; // Scale the UVs
    uv.y += TIME * speed; // Scroll texture along Y-axis

    //ALBEDO = texture(albedo_texture, uv).rgb;
	//ALBEDO = texture(albedo, uv).rgb;
	//ALBEDO = texture(, uv).rgb;
}
