shader_type spatial;
uniform float speed = 1.0;
uniform sampler2D albedo_texture : source_color;

void fragment() {
    vec2 uv = UV;
    uv.y += TIME * speed; // Scroll texture along Y-axis
    ALBEDO = texture(albedo_texture, uv).rgb;
}