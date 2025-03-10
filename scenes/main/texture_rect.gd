extends TextureRect

var start_position: Vector2
var target_position: Vector2
var animation_duration = 1.0  # Duration in seconds
var elapsed_time = 0.0
var start_delay = 5.0  # Wait this long before starting to lower
var is_animating = false
var bounce_height = 30  # How high it bounces back
var bounce_duration = 0.8
var is_bouncing = false
var fade_duration = 1.0  # How long the fade takes
var total_time = 0.0
var is_fading = false
var waiting_to_start = true


func _ready():
	visible = false
	# Hide the smaller logo
	$"../TextureRect2".visible = false
	# Store initial position
	start_position = position
	# Set target position lower than start (adjust Y value as needed)
	target_position = start_position + Vector2(0, 500)


func _process(delta):
	total_time += delta

	if waiting_to_start:
		if total_time >= start_delay:
			waiting_to_start = false
			is_animating = true
			elapsed_time = 0
		return

	# Start fading 20 seconds after the animation begins
	if total_time >= (start_delay + 20.0) and not is_fading:
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
			# Show the smaller logo
			$"../TextureRect2".visible = true
			queue_free()
			return

	elif is_animating:
		visible = true
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
