shader_type spatial;

uniform vec2 scroll_speed = vec2(1.0, 0.0);
uniform float time_scale = 1.0;
uniform sampler2D albedo_texture;

void fragment() {
    // Use an exponential scale to make the effect more noticeable
    float adjusted_scale = exp(time_scale) - 1.0;
    
    // Calculate the offset with the adjusted scale
    vec2 scroll_offset = scroll_speed * TIME * adjusted_scale;
    
    vec2 scrolled_uv = fract(UV + scroll_offset);
    ALBEDO = texture(albedo_texture, scrolled_uv).rgb;
}