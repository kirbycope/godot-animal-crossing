extends RichTextLabel

# Export variables to customize the pulsing effect
@export var pulse_duration: float = 2.0  # Duration of one complete pulse cycle
@export var min_alpha: float = 0.2       # Minimum opacity (0.0 to 1.0)
@export var max_alpha: float = 1.0       # Maximum opacity (0.0 to 1.0)
@export var auto_start: bool = true      # Whether to start pulsing automatically

# Internal variables
var time_passed: float = 0.0
var is_pulsing: bool = false
var original_modulate: Color

func _ready():
	# Store the original color/modulate value
	original_modulate = modulate
	
	# Start pulsing if auto_start is enabled
	if auto_start:
		start_pulse()

func _process(delta):
	if is_pulsing:
		# Update the time counter
		time_passed += delta
		
		# Calculate the current phase of the pulse (0.0 to 1.0)
		var phase = fmod(time_passed, pulse_duration) / pulse_duration
		
		# Use sine wave to create smooth pulsing effect
		var alpha = lerp(min_alpha, max_alpha, 
						(sin(phase * TAU - PI/2) + 1.0) / 2.0)
		
		# Apply the new opacity while maintaining original RGB values
		modulate = Color(original_modulate.r, 
						original_modulate.g,
						original_modulate.b, 
						alpha)

# Public functions to control the pulsing effect
func start_pulse():
	is_pulsing = true
	time_passed = 0.0

func stop_pulse():
	is_pulsing = false
	# Reset to original appearance
	modulate = original_modulate

func toggle_pulse():
	if is_pulsing:
		stop_pulse()
	else:
		start_pulse()

# Optional: Add method to change pulse parameters at runtime
func set_pulse_parameters(duration: float, min_opacity: float, max_opacity: float):
	pulse_duration = max(0.1, duration)  # Ensure duration is positive
	min_alpha = clampf(min_opacity, 0.0, 1.0)
	max_alpha = clampf(max_opacity, 0.0, 1.0)
	
	# Swap values if min is greater than max
	if min_alpha > max_alpha:
		var temp = min_alpha
		min_alpha = max_alpha
		max_alpha = temp
