extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const RADIUS = 11.156 # Radius of the cylinder in meters

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:

	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Animate movement
	if input_dir != Vector2.ZERO:
		if animation_player.current_animation != "walking":
			animation_player.play("walking")
	# Handle forward/backward movement by rotating the world around the y-axis.
	if input_dir.y != 0:
		# Calculate the rotation angle based on input and speed.
		var angle := -(input_dir.y * SPEED * delta) / RADIUS
		# Rotate the world around the x-axis.
		$"../World".rotate_x(angle)

	# Handle left/right movement by moving the player physically.
	if input_dir.x != 0:
		velocity.x = input_dir.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply the vertical and horizontal movement.
	move_and_slide()
