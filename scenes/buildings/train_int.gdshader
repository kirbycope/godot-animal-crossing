shader_type spatial;

// Speed of scrolling in u and v directions
uniform vec2 scroll_speed = vec2(1.0, 0.0); // Default scrolls horizontally
uniform float time_scale = 1.0;             // Control overall speed
uniform sampler2D albedo_texture;           // Main texture

void fragment() {
    // Calculate the offset based on time
    vec2 scroll_offset = scroll_speed * TIME * time_scale;
    
    // Apply the scrolling offset to the UV coordinates
    // Using fract to wrap around and create continuous scrolling
    vec2 scrolled_uv = fract(UV + scroll_offset);
    
    // Sample the texture with the scrolled coordinates
    ALBEDO = texture(albedo_texture, scrolled_uv).rgb;
}