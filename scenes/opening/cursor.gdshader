shader_type canvas_item;

uniform float bob_speed : hint_range(0.1, 10.0) = 2.0;
uniform float bob_amplitude : hint_range(1.0, 50.0) = 20.0;

void vertex() {
    // Calculate bobbing offset using TIME built-in variable
    float bob_offset = sin(TIME * TAU * bob_speed);
    
    // Apply offset to vertex position
    VERTEX.y += bob_offset * bob_amplitude;
}
