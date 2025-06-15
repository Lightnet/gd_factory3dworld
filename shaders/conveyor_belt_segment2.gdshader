shader_type spatial;
uniform float speed = 1.0; // Controls scrolling speed
uniform vec2 texture_scale = vec2(1.0, 1.0); // Controls texture tiling (X, Y)
uniform sampler2D albedo_texture : source_color;

void fragment() {
    vec2 uv = UV;
    uv *= texture_scale; // Scale the UVs to adjust texture tiling
    uv.y += TIME * speed; // Scroll texture along Y-axis
    ALBEDO = texture(albedo_texture, uv).rgb;
}