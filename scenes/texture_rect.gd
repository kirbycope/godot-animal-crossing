extends TextureRect

var start_position: Vector2
var target_position: Vector2
var animation_duration = 1.0  # Duration in seconds
var elapsed_time = 0.0
var is_animating = false
var bounce_height = 30  # How high it bounces back
var bounce_duration = 0.8
var is_bouncing = false
var fade_delay = 3.0  # Time before starting fade
var fade_duration = 1.0  # How long the fade takes
var total_time = 0.0
var is_fading = false

func _ready():
	# Store initial position
	start_position = position
	# Set target position lower than start (adjust Y value as needed)
	target_position = start_position + Vector2(0, 200)
	is_animating = true

func _process(delta):
	total_time += delta
	
	if total_time >= fade_delay and not is_fading:
		is_fading = true
		elapsed_time = 0  # Reset for fade animation
	
	if is_fading:
		elapsed_time += delta
		var fade_progress = elapsed_time / fade_duration
		
		if fade_progress <= 1.0:
			# Fade out smoothly
			modulate.a = 1.0 - ease(fade_progress, -2.0)
		else:
			# Complete fade out and optionally remove node
			modulate.a = 0
			queue_free()
			return
			
	elif is_animating:
		elapsed_time += delta
		var progress = elapsed_time / animation_duration
		
		if progress <= 1.0:
			# Main dropping animation
			position = start_position.lerp(target_position, ease(progress, -2.0))
		else:
			# Start bounce
			is_animating = false
			is_bouncing = true
			elapsed_time = 0
	
	elif is_bouncing:
		elapsed_time += delta
		var bounce_progress = elapsed_time / bounce_duration
		
		if bounce_progress <= 1.0:
			# Bounce up and down using sine wave
			var bounce_offset = sin(bounce_progress * PI) * bounce_height
			position = target_position - Vector2(0, bounce_offset)
		else:
			# End at target position
			position = target_position
			is_bouncing = false
