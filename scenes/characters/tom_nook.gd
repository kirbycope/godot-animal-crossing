extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const RADIUS = 11.156 # Radius of the cylinder in meters

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:

	# Enable virtual (touch) controller
	$CanvasLayer/VirtualController3D.process_mode = Node.PROCESS_MODE_INHERIT


func _physics_process(delta: float) -> void:

	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Translate controls (from virtual controller)
	translate_controls()

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


func translate_controls() -> void:
	# Forward "move_up" to "ui_up"
	if Input.is_action_pressed("move_up"):
		Input.action_press("ui_up")
	elif Input.is_action_just_released("move_up"):
		Input.action_release("ui_up")
	
	# Forward "move_down" to "ui_down"
	if Input.is_action_pressed("move_down"):
		Input.action_press("ui_down")
	elif Input.is_action_just_released("move_down"):
		Input.action_release("ui_down")
	
	# Forward "move_left" to "ui_left"
	if Input.is_action_pressed("move_left"):
		Input.action_press("ui_left")
	elif Input.is_action_just_released("move_left"):
		Input.action_release("ui_left")
	
	# Forward "move_right" to "ui_right"
	if Input.is_action_pressed("move_right"):
		Input.action_press("ui_right")
	elif Input.is_action_just_released("move_right"):
		Input.action_release("ui_right")
