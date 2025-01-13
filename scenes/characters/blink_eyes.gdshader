shader_type spatial;

uniform sampler2D texture_1 : source_color;  // Main texture
uniform sampler2D texture_2 : source_color;  // Second texture
uniform sampler2D texture_3 : source_color;  // Third texture

// Constants for timing
const float BLINK_DURATION = 0.1;    // Duration for each blink phase
const float MIN_INTERVAL = 2.0;      // Minimum time between blink sequences
const float MAX_INTERVAL = 10.0;     // Maximum time between blink sequences

// Simple random function based on time
float random(float x) {
    return fract(sin(x * 12.9898) * 43758.5453);
}

// Get random interval between MIN_INTERVAL and MAX_INTERVAL
float get_random_interval(float seed) {
    return MIN_INTERVAL + random(seed) * (MAX_INTERVAL - MIN_INTERVAL);
}

void fragment() {
    // Scale UV coordinates horizontally
    vec2 scaled_uv = vec2(UV.x * 0.5, UV.y);
    
    float time = TIME;
    
    // Calculate the current cycle start time
    float cycle_start = 0.0;
    float current_time = 0.0;
    float interval = get_random_interval(floor(time / 3.0));  // New random interval every 3 seconds
    
    // Find current position in the blink sequence
    float blink_sequence_time = mod(time, interval + BLINK_DURATION * 3.0);
    
    // Sample all textures with scaled UV
    vec4 tex1_color = texture(texture_1, scaled_uv);
    vec4 tex2_color = texture(texture_2, scaled_uv);
    vec4 tex3_color = texture(texture_3, scaled_uv);
    
    // Determine which texture to display based on the blink sequence time
    vec4 final_color;
    
    if (blink_sequence_time < BLINK_DURATION) {
        // First blink: texture 2
        final_color = tex2_color;
    } else if (blink_sequence_time < BLINK_DURATION * 2.0) {
        // Second blink: texture 3
        final_color = tex3_color;
    } else if (blink_sequence_time < BLINK_DURATION * 3.0) {
        // Third blink: back to texture 2
        final_color = tex2_color;
    } else {
        // Rest state: texture 1
        final_color = tex1_color;
    }

    ALBEDO = final_color.rgb;
}